import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Phase 3 Part 5 — real implementation, replacing the Part 1
/// architecture-only stub. One shared layout serves every report: a
/// header (store name + report title + generated-at timestamp), the
/// report's summary cards as a wrapped grid, and each table rendered
/// via `pw.TableHelper.fromTextArray`. This deliberately does NOT try to
/// visually match the on-screen design pixel-for-pixel (per the Phase 3
/// spec: "Create architecture for printing. Do not redesign UI." — the
/// UI in question is the *screen* UI, and a PDF is a different medium
/// with different constraints, e.g. no hover states, fixed page width).
///
/// [PrintableReport] / [PrintableSection] are unchanged from Part 1 —
/// every report screen already builds these from data it has already
/// loaded, the same values it hands to [ReportExportService].
class ReportPrintService {
  ReportPrintService._();

  /// [storeName] should be resolved from `settings.store_name` by the
  /// caller before calling this (the settings repository/service isn't
  /// in scope here yet). Left nullable rather than required so existing
  /// call sites don't break immediately; falls back to a neutral label
  /// — NOT a branded placeholder like the old 'Inventory Pro' default —
  /// so it's obvious in output that the real name wasn't wired up yet.
  /// TODO: thread the real settings.store_name through every call site
  /// (see SalesReportScreen._print and its siblings) and drop the
  /// fallback once that's done.
  static Future<void> printReport(
    PrintableReport report, {
    String? storeName,
  }) async {
    final resolvedStoreName = (storeName == null || storeName.trim().isEmpty) ? 'Store' : storeName;
    final doc = pw.Document();
    final generatedAt = DateTime.now();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        header: (context) => _buildHeader(resolvedStoreName, report.title, generatedAt),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          pw.Text(
            report.subtitle,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 14),
          for (final section in report.sections) ...[
            _buildSection(section),
            pw.SizedBox(height: 18),
          ],
        ],
      ),
    );

    // layoutPdf opens the OS print dialog (Windows: system print/PDF
    // driver picker) rather than silently writing a file — matches
    // "Print" as a user-facing action, not an export.
    //
    // `printing`'s desktop/Windows backend can fail for reasons outside
    // this app's control — no printer driver registered, the plugin's
    // native channel missing, the OS print subsystem unavailable, etc.
    // Those surface as PlatformException/MissingPluginException, not
    // anything named "PrintingNotAvailableException" (that type didn't
    // exist anywhere in this file before). Every report screen already
    // has a `catch (PrintingNotAvailableException)` clause written
    // against it, so define the type and translate real failures into
    // it here rather than leaving that catch clause dead code.
    try {
      await Printing.layoutPdf(onLayout: (format) async => doc.save());
    } catch (e) {
      throw PrintingNotAvailableException(
        'Printing is not available on this device: $e',
      );
    }
  }

  static pw.Widget _buildHeader(String storeName, String title, DateTime generatedAt) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              storeName,
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
            ),
            pw.Text(_formatDateTime(generatedAt), style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 1, color: PdfColors.grey400),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }

  static pw.Widget _buildSection(PrintableSection section) {
    return switch (section) {
      PrintableSummaryCards(:final cards) => pw.Wrap(
          spacing: 14,
          runSpacing: 10,
          children: [
            for (final (label, value) in cards)
              pw.Container(
                width: 130,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.75),
                  borderRadius: pw.BorderRadius.circular(3),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      label.toUpperCase(),
                      style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(value, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      PrintableTable(:final title, :final headers, :final rows) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            // fromTextArray paginates automatically across pages within
            // a MultiPage build — this is what makes a several-hundred-
            // row ledger (Stock Movement) safe to print without a
            // separate "large table" code path.
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: rows,
              headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              cellStyle: const pw.TextStyle(fontSize: 8),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
              ),
            ),
          ],
        ),
    };
  }

  static String _formatDateTime(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
}

/// Unchanged from Phase 3 Part 1 — the contract every report screen
/// already builds against.
class PrintableReport {
  final String title;
  final String subtitle;
  final List<PrintableSection> sections;

  const PrintableReport({
    required this.title,
    required this.subtitle,
    required this.sections,
  });
}

sealed class PrintableSection {
  const PrintableSection();
}

class PrintableSummaryCards extends PrintableSection {
  final List<(String label, String value)> cards;
  const PrintableSummaryCards(this.cards);
}

class PrintableTable extends PrintableSection {
  final String title;
  final List<String> headers;
  final List<List<String>> rows;
  const PrintableTable({required this.title, required this.headers, required this.rows});
}

/// Thrown by [ReportPrintService.printReport] when the OS print
/// subsystem / `printing` plugin can't complete the request — no
/// printer driver, missing native channel, etc. Every report screen
/// already writes `catch (PrintingNotAvailableException)` around its
/// print call and shows a "Printing will be available soon." snackbar;
/// this type didn't previously exist anywhere in this file, so that
/// catch clause could never actually match a thrown error.
class PrintingNotAvailableException implements Exception {
  final String message;
  const PrintingNotAvailableException(this.message);

  @override
  String toString() => 'PrintingNotAvailableException: $message';
}
