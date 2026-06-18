
class StockEntrySummary {
  final int totalReceipts;
  final int totalItems;
  final double totalValue;

  final int pendingReceipts;
  final int verifiedReceipts;
  final int cancelledReceipts;

  const StockEntrySummary({
    required this.totalReceipts,
    required this.totalItems,
    required this.totalValue,
    required this.pendingReceipts,
    required this.verifiedReceipts,
    required this.cancelledReceipts,
  });


  const StockEntrySummary.empty()
      : totalReceipts = 0,
        totalItems = 0,
        totalValue = 0.0,
        pendingReceipts = 0,
        verifiedReceipts = 0,
        cancelledReceipts = 0;
}
