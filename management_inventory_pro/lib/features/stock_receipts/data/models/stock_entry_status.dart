enum StockEntryStatus {
  pending('pending'),
  verified('verified'),
  cancelled('cancelled');

  final String value;
  const StockEntryStatus(this.value);

  static StockEntryStatus fromString(String s) =>
      StockEntryStatus.values.firstWhere(
            (e) => e.value == s,
        orElse: () => StockEntryStatus.pending,
      );

  String get label {
    switch (this) {
      case StockEntryStatus.pending:
        return 'Pending';
      case StockEntryStatus.verified:
        return 'Verified';
      case StockEntryStatus.cancelled:
        return 'Cancelled';
    }
  }
}