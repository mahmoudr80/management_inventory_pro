import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import '../../../data/models/settings_model.dart';
import '../cards/receipt_preview_card.dart';
import '../cards/settings_card.dart';
import '../fields/settings_dropdown.dart';
import '../fields/settings_switch_tile.dart';
import '../fields/settings_text_field.dart';

const _receiptWidths = [58, 80, 112];

/// "Receipt" card — thermal-printer format plus a live preview so changes
/// are visible before anything gets printed.
class ReceiptSection extends StatelessWidget {
  final ReceiptSettings receipt;
  final ValueChanged<ReceiptSettings> onChanged;

  const ReceiptSection({super.key, required this.receipt, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Receipts',
      description: 'Format & printing',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;

          final form = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsDropdown<int>(
                label: 'Receipt Width',
                value: receipt.widthMm,
                options: _receiptWidths,
                labelBuilder: (v) => '$v mm',
                onChanged: (v) => onChanged(receipt.copyWith(widthMm: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsTextField(
                label: 'Header Text',
                initialValue: receipt.header,
                maxLines: 2,
                onChanged: (v) => onChanged(receipt.copyWith(header: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsTextField(
                label: 'Footer Text',
                initialValue: receipt.footer,
                maxLines: 2,
                onChanged: (v) => onChanged(receipt.copyWith(footer: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsSwitchTile(
                title: 'Show Logo',
                value: receipt.showLogo,
                onChanged: (v) => onChanged(receipt.copyWith(showLogo: v)),
              ),
              SizedBox(height: AppSpacing.md),
              SettingsSwitchTile(
                title: 'Show Tax Breakdown',
                value: receipt.showTax,
                onChanged: (v) => onChanged(receipt.copyWith(showTax: v)),
              ),
              SizedBox(height: AppSpacing.md),
              SettingsSwitchTile(
                title: 'Show Cashier Name',
                value: receipt.showCashier,
                onChanged: (v) => onChanged(receipt.copyWith(showCashier: v)),
              ),
            ],
          );

          final preview = ReceiptPreviewCard(receipt: receipt);

          if (isNarrow) {
            return Column(
              children: [form, SizedBox(height: AppSpacing.xl), preview],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: form),
              SizedBox(width: AppSpacing.xl),
              Expanded(flex: 2, child: preview),
            ],
          );
        },
      ),
    );
  }
}
