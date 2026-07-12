import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
/// Generic export for any report table: every report screen already has
/// its rows as `List<List<String>>` by the time it calls this (each
/// screen maps its typed row model -> plain strings itself, the same way
/// [_export] does in SalesReportScreen), so this service stays fully
/// report-agnostic — it never imports a single report's model classes.
///
/// SCOPE NOTE: this exports whatever rows the caller passes in — i.e.
/// the *currently loaded page*, matching what's on screen. Exporting the
/// full filtered result set (all pages) would need a dedicated
/// "fetch all matching rows, unpaginated" query per datasource, which is
/// a bigger, report-by-report change than this pass covers. Flagged
/// here rather than silently only exporting a page: surface this as a
/// caveat in the button's tooltip ("Exports current page") until that
/// follow-up lands.
///
/// PLATFORM NOTE: uses `file_picker`'s `saveFile`, which already covers
/// desktop (Windows) — the only platform this app's Reports feature
/// runs on per `service_locator.dart`'s `Platform.isWindows` gate.
class ReportExportService {
  ReportExportService._();

  static Future<void> exportCsv({
    required String fileNameWithoutExtension,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    final csvData = csv.encode([
      headers,
      ...rows,
    ]);
    await _saveBytes(
      fileNameWithoutExtension: fileNameWithoutExtension,
      extension: 'csv',
      bytes: utf8.encode(csvData),
    );
  }

  static Future<void> exportExcel({
    required String fileNameWithoutExtension,
    required String sheetName,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    final workbook = Excel.createExcel();
    final sheet = workbook[sheetName];
    // Excel.createExcel() ships with a default 'Sheet1' — drop it once
    // our named sheet exists so the exported file doesn't carry a blank
    // extra tab.
    if (workbook.sheets.containsKey('Sheet1') && sheetName != 'Sheet1') {
      workbook.delete('Sheet1');
    }

    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    for (final row in rows) {
      sheet.appendRow(row.map((cell) => TextCellValue(cell)).toList());
    }

    final bytes = workbook.save();
    if (bytes == null) {
      throw StateError('Failed to encode Excel workbook.');
    }

    await _saveBytes(
      fileNameWithoutExtension: fileNameWithoutExtension,
      extension: 'xlsx',
      bytes: bytes,
    );
  }

  static Future<void> _saveBytes({
    required String fileNameWithoutExtension,
    required String extension,
    required List<int> bytes,
  }) async {
    final path = await FilePicker.saveFile(
      fileName: '$fileNameWithoutExtension.$extension',
      type: FileType.custom,
      allowedExtensions: [extension],
    );
    if (path == null) return; // user cancelled the save dialog
    await File(path).writeAsBytes(bytes, flush: true);
  }
}
