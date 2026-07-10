import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme_extension.dart';
import '../../theme/dashboard_theme_extension.dart';
import '../../../data/models/low_stock_product.dart';

class LowStockRow extends StatelessWidget {
  const LowStockRow({
    super.key,
    required this.product,
    required this.onRestock,
  });

  final LowStockProductRef product;
  final VoidCallback onRestock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dashColors = context.dashboardColors;
    final isCritical = product.status == LowStockStatus.critical ||
        product.status == LowStockStatus.outOfStock;

    return Container(
      decoration: BoxDecoration(
        color: isCritical ? dashColors.errorContainer.withOpacity(0.08) : null,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Text(
                product.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          _NumCell(value: '${product.currentStock}'),
          _NumCell(value: '${product.minimumStock}'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _StatusChip(status: product.status),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: onRestock,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              child: const Text('Restock Now'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumCell extends StatelessWidget {
  const _NumCell({required this.value});
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontFamily: 'JetBrains Mono',
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final LowStockStatus status;

  @override
  Widget build(BuildContext context) {
    final coreColors = context.colors;
    final dashColors = context.dashboardColors;
    final (label, bg, fg) = switch (status) {
      LowStockStatus.critical => ('CRITICAL', dashColors.errorContainer, coreColors.error),
      LowStockStatus.outOfStock => ('OUT OF STOCK', dashColors.errorContainer, coreColors.error),
      LowStockStatus.warning => ('WARNING', dashColors.warningContainer, dashColors.onWarningContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.08,
        ),
      ),
    );
  }
}