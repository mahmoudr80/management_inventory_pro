import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/recent_stock_entry.dart';

class RecentStockEntryRow extends StatelessWidget {
  const RecentStockEntryRow({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final RecentStockEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final egp = NumberFormat('#,###', 'en_US');

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: _PaddedCell(
                child: Text(
                  entry.receiptId,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'JetBrains Mono',
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _PaddedCell(
                child: Text(
                  entry.supplier.name??'',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: _PaddedCell(
                child: Text(
                  '${egp.format(entry.totalCost)} EGP',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 110,
              child: Center(child: _StockEntryStatusChip(status: entry.status)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaddedCell extends StatelessWidget {
  const _PaddedCell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: child,
    );
  }
}

class _StockEntryStatusChip extends StatelessWidget {
  const _StockEntryStatusChip({required this.status});
  final StockEntryStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      StockEntryStatus.received =>
        ('RECEIVED', const Color(0xFFD6F4E3), const Color(0xFF1B6E3C)),
      StockEntryStatus.inTransit =>
        ('IN TRANSIT', const Color(0xFFD0E1FB), const Color(0xFF0041C8)),
      StockEntryStatus.pending =>
        ('PENDING', const Color(0xFFFFF3CD), const Color(0xFF8A6200)),
      StockEntryStatus.cancelled =>
        ('CANCELLED', const Color(0xFFFFDAD6), const Color(0xFFBA1A1A)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
    );
  }
}
