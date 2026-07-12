import 'package:flutter/foundation.dart';

/// A named, closed date interval used to scope every report query.
/// [preset] drives the label shown in the filter bar; `custom` means the
/// user picked [start]/[end] directly rather than choosing a preset.
enum ReportDateRangePreset {
  today,
  yesterday,
  thisWeek,
  last7Days,
  last30Days,
  thisMonth,
  lastMonth,
  custom,
}

@immutable
class ReportDateRange {
  final ReportDateRangePreset preset;
  final DateTime start;
  final DateTime end;

  const ReportDateRange({required this.preset, required this.start, required this.end});

  static DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime _endOfDay(DateTime d) => DateTime(d.year, d.month, d.day, 23, 59, 59);

  factory ReportDateRange.today() {
    final now = DateTime.now();
    // "So far today" — end is now, not end-of-day, since the rest of
    // today hasn't happened yet.
    return ReportDateRange(preset: ReportDateRangePreset.today, start: _startOfDay(now), end: now);
  }

  factory ReportDateRange.yesterday() {
    final startOfToday = _startOfDay(DateTime.now());
    final yesterday = startOfToday.subtract(const Duration(days: 1));
    // Yesterday is fully in the past, so unlike Today it gets a real
    // end-of-day bound rather than "now" — otherwise anything after
    // whatever time it currently is would be excluded.
    return ReportDateRange(preset: ReportDateRangePreset.yesterday, start: yesterday, end: _endOfDay(yesterday));
  }

  factory ReportDateRange.thisWeek() {
    final now = DateTime.now();
    final startOfToday = _startOfDay(now);
    // Monday-start week (DateTime.weekday: Monday == 1 .. Sunday == 7).
    final startOfWeek = startOfToday.subtract(Duration(days: now.weekday - 1));
    return ReportDateRange(preset: ReportDateRangePreset.thisWeek, start: startOfWeek, end: now);
  }

  factory ReportDateRange.last7Days() {
    final now = DateTime.now();
    return ReportDateRange(
      preset: ReportDateRangePreset.last7Days,
      start: _startOfDay(now).subtract(const Duration(days: 6)),
      end: now,
    );
  }

  factory ReportDateRange.last30Days() {
    final now = DateTime.now();
    return ReportDateRange(
      preset: ReportDateRangePreset.last30Days,
      start: _startOfDay(now).subtract(const Duration(days: 29)),
      end: now,
    );
  }

  factory ReportDateRange.thisMonth() {
    final now = DateTime.now();
    return ReportDateRange(
      preset: ReportDateRangePreset.thisMonth,
      start: DateTime(now.year, now.month, 1),
      end: now,
    );
  }

  factory ReportDateRange.lastMonth() {
    final now = DateTime.now();
    final firstOfThisMonth = DateTime(now.year, now.month, 1);
    final lastDayOfLastMonth = firstOfThisMonth.subtract(const Duration(days: 1));
    // FIX: last month is a fully-elapsed period, so its end must be the
    // *end* of its final day, not midnight of that day. The previous
    // version used `lastDayOfLastMonth` (which is midnight, 00:00:00)
    // directly as `end`, so every sale/entry after midnight on the last
    // day of the month — i.e. nearly the entire day — fell outside the
    // BETWEEN range and was excluded.
    return ReportDateRange(
      preset: ReportDateRangePreset.lastMonth,
      start: DateTime(lastDayOfLastMonth.year, lastDayOfLastMonth.month, 1),
      end: _endOfDay(lastDayOfLastMonth),
    );
  }

  factory ReportDateRange.custom(DateTime start, DateTime end) =>
      ReportDateRange(preset: ReportDateRangePreset.custom, start: start, end: end);

  String get label {
    switch (preset) {
      case ReportDateRangePreset.today:
        return 'Today';
      case ReportDateRangePreset.yesterday:
        return 'Yesterday';
      case ReportDateRangePreset.thisWeek:
        return 'This Week';
      case ReportDateRangePreset.last7Days:
        return 'Last 7 Days';
      case ReportDateRangePreset.last30Days:
        return 'Last 30 Days';
      case ReportDateRangePreset.thisMonth:
        return 'This Month';
      case ReportDateRangePreset.lastMonth:
        return 'Last Month';
      case ReportDateRangePreset.custom:
        return 'Custom Range';
    }
  }

  /// Bounds for SQLite TEXT date comparisons.
  ///
  /// IMPORTANT: every timestamp this app writes (`created_at`,
  /// `updated_at`, `receipt_date` — see StockEntryModel.toMap,
  /// CartModel.toMap, StockEntryDatasource, PosDatasource) is produced by
  /// `DateTime.now()` (LOCAL time), formatted as space-delimited,
  /// zero-padded, no-fractional-seconds text. Nothing in this app writes
  /// UTC timestamps or relies on SQLite's `CURRENT_TIMESTAMP`.
  ///
  /// The previous version of this method converted [start]/[end] to UTC
  /// before formatting, on the mistaken assumption that stored rows were
  /// UTC. That meant the WHERE clause compared a UTC boundary against
  /// locally-stored values — offset by the device's UTC difference — so
  /// rows near either edge of the range were silently dropped or
  /// included depending on the sign of the offset. The fix is NOT to
  /// convert to UTC at all: format [start]/[end] as local wall-clock
  /// text, in the same shape the write side already produces, so both
  /// sides of the comparison speak the same clock.
  String get startIso => _sqliteLocal(start);
  String get endIso => _sqliteLocal(end);

  static String _sqliteLocal(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year.toString().padLeft(4, '0')}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ReportDateRange &&
              other.preset == preset &&
              other.start == start &&
              other.end == end);

  @override
  int get hashCode => Object.hash(preset, start, end);
}