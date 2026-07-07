import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../sale_history/data/models/sale_item_model.dart';
import '../../../data/models/recent_sale.dart';

class RecentSaleRow extends StatelessWidget {
  const RecentSaleRow({
    super.key,
    required this.sale,
    required this.onTap,
  });

  final RecentSaleRef sale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFmt = DateFormat('MMM d, HH:mm');
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
            _Cell(
                width: 100,
                child: Tooltip(
                  message: sale.id,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    sale.id,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'JetBrains Mono',
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                )),
            _Cell(
                flex: 1,
                child: Tooltip(
                  message: dateFmt.format(sale.date),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    dateFmt.format(sale.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                )),
            _Cell(
                flex: 1,
                child: Tooltip(
                  message: sale.cashier,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    sale.cashier,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                )),
            _Cell(
                align: CrossAxisAlignment.end,
                width: 110,
                child: Tooltip(
                  message: '${egp.format(sale.totalAmount)} EGP',
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    '${egp.format(sale.totalAmount)} EGP',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                )),
            _Cell(
              align: CrossAxisAlignment.center,
              width: 60,
              child: _SaleStatusDot(status: sale.status),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.child,
    this.width,
    this.flex,
    this.align = CrossAxisAlignment.start,
  });

  final Widget child;
  final double? width;
  final int? flex;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    final inner = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: align == CrossAxisAlignment.start
          ? child
          : Column(
              crossAxisAlignment: align,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [child],
            ),
    );
    if (width != null) return SizedBox(width: width, child: inner);
    return Expanded(flex: flex ?? 1, child: inner);
  }
}

class _SaleStatusDot extends StatelessWidget {
  const _SaleStatusDot({required this.status});
  final SaleStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SaleStatus.completed => AppColors.success,
      SaleStatus.refunded => AppColors.warning,
      SaleStatus.cancelled => AppColors.error,
    };
    return Tooltip(
        message: status.name,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ));
  }
}
