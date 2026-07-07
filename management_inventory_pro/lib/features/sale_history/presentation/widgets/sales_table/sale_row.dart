import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';
import '../../../data/models/sale_item_model.dart';
import '../../../data/models/sale_model.dart';

class SaleRow extends StatefulWidget {
  const SaleRow({
    super.key,
    required this.sale,
    required this.isSelected,
    required this.onTap,
  });

  final SaleModel sale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<SaleRow> createState() => _SaleRowState();
}

class _SaleRowState extends State<SaleRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final sale = widget.sale;
    Color bgColor = Colors.transparent;
    if (widget.isSelected) {
      bgColor = AppColors.surfaceContainer;
    } else if (_isHovered) {
      bgColor = AppColors.surfaceContainerLow;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
          color: bgColor,
          child: Row(
            children: [
              // Sale ID
              Expanded(
                flex: 2,
                child: Tooltip(
                  message: sale.id,
                  child: Text(
                    sale.id,
                    style: AppTextStyles.bodySm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Date & Time
              Expanded(
                flex: 3,
                child: Tooltip(
                  message: DateFormat('MMM d, yyyy hh:mm a').format(sale.createdAt),
                  child: Text(
                    DateFormat('MMM d, yyyy hh:mm a').format(sale.createdAt),
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Items Count
              Expanded(
                flex: 1,
                child: Text(
                  sale.totalItems.toString(),
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              // Quantity
              Expanded(
                flex: 1,
                child: Text(
                  sale.totalQuantity.toString(),
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              // Total Amount
              Expanded(
                flex: 2,
                child: Tooltip(
                  message: '\$${sale.totalAmount.toStringAsFixed(2)}',
                  child: Text(
                    '\$${sale.totalAmount.toStringAsFixed(2)}',
                    style: AppTextStyles.bodySm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Payment Method Badge
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _PaymentBadge(method: sale.paymentMethod),
                ),
              ),

              // Cashier
              Expanded(
                flex: 2,
                child: Tooltip(
                  message: sale.cashierName,
                  child: Text(
                    sale.cashierName,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                size: AppSpacing.lg,
                color: widget.isSelected
                    ? AppColors.primary
                    : AppColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  const _PaymentBadge({required this.method});
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (method) {
      PaymentMethod.cash => ('Cash', AppColors.statusHealthyBg, AppColors.statusHealthyFg),
      PaymentMethod.card => ('Card', AppColors.infoContainer, AppColors.info),
      PaymentMethod.mixed => ('Mixed', AppColors.statusPendingBg, AppColors.statusPendingFg),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySm.copyWith(
          fontWeight: FontWeight.w600,
          color: fg,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
