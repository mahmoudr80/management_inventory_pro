import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../data/models/recent_stock_entry.dart';

class RecentStockEntryRow extends StatelessWidget {
  const RecentStockEntryRow({
    super.key,
    required this.entry,
    required this.onTap,
  });

  final RecentStockEntryRef entry;
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
            Expanded(
                child: _PaddedCell(
              child: Tooltip(
                message: entry.receiptId,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  entry.receiptId,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'JetBrains Mono',
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            )),
            Expanded(
              child: _PaddedCell(
                child: Tooltip(
                  message: entry.supplier.name ?? '',
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    entry.supplier.name ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: _PaddedCell(
              child: Tooltip(
                message: '${egp.format(entry.totalCost)} EGP',
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  '${egp.format(entry.totalCost)} EGP',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            )),
            Expanded(
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
        ('RECEIVED', AppColors.successContainer, AppColors.success),
      StockEntryStatus.inTransit =>
        ('IN TRANSIT', AppColors.secondaryContainer, AppColors.primary),
      StockEntryStatus.pending =>
        ('PENDING', AppColors.warningContainer, AppColors.onWarningContainer),
      StockEntryStatus.cancelled =>
        ('CANCELLED', AppColors.errorContainer, AppColors.error),
    };
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Tooltip(
          message: label,
          child: Text(
            overflow: TextOverflow.ellipsis,
            label,
            style: TextStyle(
              color: fg,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
          ),
        ));
  }
}
