import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

import '../../../data/models/settings_model.dart';

/// Live preview of a thermal receipt reflecting the current
/// [ReceiptSettings] — width, header/footer text, and which optional
/// lines (logo, tax, cashier) are switched on.
class ReceiptPreviewCard extends StatelessWidget {
  final ReceiptSettings receipt;

  const ReceiptPreviewCard({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    // Scale the 58–112mm thermal-paper range to a readable on-screen width.
    final previewWidth = (receipt.widthMm * 2.6).clamp(180.0, 320.0);

    return Center(
      child: Container(
        width: previewWidth,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: context.colors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: context.colors.textPrimary.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (receipt.showLogo) ...[
              Icon(Icons.inventory_2_rounded, color: context.colors.primary, size: AppIconSize.lg),
              SizedBox(height: AppSpacing.xs),
            ],
            Text(
              receipt.header,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AppSpacing.sm),
            _dashedDivider(),
            SizedBox(height: AppSpacing.sm),
            _receiptLine(context, '2x Wireless Mouse', '540.00'),
            _receiptLine(context, '1x USB-C Cable', '120.00'),
            SizedBox(height: AppSpacing.xs),
            _dashedDivider(),
            SizedBox(height: AppSpacing.xs),
            _receiptLine(context, 'Subtotal', '660.00'),
            if (receipt.showTax) _receiptLine(context, 'Tax', '92.40'),
            _receiptLine(context, 'Total', '752.40', emphasize: true),
            if (receipt.showCashier) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                'Cashier: Mahmoud S.',
                style: AppTextStyles.bodySm.copyWith(color: context.colors.outline),
              ),
            ],
            SizedBox(height: AppSpacing.sm),
            _dashedDivider(),
            SizedBox(height: AppSpacing.sm),
            Text(
              receipt.footer,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm.copyWith(color: context.colors.outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashedDivider() {
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / 6).floor();
          return Row(
            children: List.generate(
              dashCount,
              (_) => Expanded(
                child: Container(height: 1, color: context.colors.outlineVariant),
              ),
            ).expand((w) => [w, SizedBox(width: 2)]).toList(),
          );
        },
      ),
    );
  }

  Widget _receiptLine(BuildContext context, String label, String amount, {bool emphasize = false}) {
    final style = AppTextStyles.dataMono.copyWith(
      fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400,
      color: context.colors.textPrimary,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
          ),
          Text(amount, style: style),
        ],
      ),
    );
  }
}
