/// Date range options exposed in the filter bar's date dropdown.
enum DateRangeFilter {
  today,
  last7Days,
  last30Days,
  allTime;

  String get label {
    switch (this) {
      case DateRangeFilter.today:
        return 'Today';
      case DateRangeFilter.last7Days:
        return 'Last 7 Days';
      case DateRangeFilter.last30Days:
        return 'Last 30 Days';
      case DateRangeFilter.allTime:
        return 'All Time';
    }
  }

  bool includes(DateTime dateTime, DateTime now) {
    switch (this) {
      case DateRangeFilter.today:
        return dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day;
      case DateRangeFilter.last7Days:
        return now.difference(dateTime).inDays <= 7;
      case DateRangeFilter.last30Days:
        return now.difference(dateTime).inDays <= 30;
      case DateRangeFilter.allTime:
        return true;
    }
  }
}
