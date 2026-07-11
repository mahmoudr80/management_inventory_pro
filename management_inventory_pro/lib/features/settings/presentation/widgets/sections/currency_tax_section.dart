import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

import '../../../data/models/settings_model.dart';
import '../cards/settings_card.dart';
import '../fields/settings_dropdown.dart';
import '../fields/settings_number_field.dart';
import '../fields/settings_switch_tile.dart';

const _currencies = ['EGP', 'USD', 'EUR', 'SAR', 'AED'];
const _precisionOptions = [0, 1, 2, 3];

/// "Currency & Tax" card — rates, rounding, and a live preview of how a
/// sample sale is taxed, so the effect of every toggle is immediately
/// visible instead of abstract.
class CurrencyTaxSection extends StatelessWidget {
  final CurrencyTaxSettings currencyTax;
  final ValueChanged<CurrencyTaxSettings> onChanged;

  const CurrencyTaxSection({super.key, required this.currencyTax, required this.onChanged});

  static const double _samplePrice = 1200;

  @override
  Widget build(BuildContext context) {
    final tax = currencyTax.taxEnabled ? _samplePrice * (currencyTax.taxPercent / 100) : 0;
    final total = _samplePrice + tax;
    final precision = currencyTax.decimalPrecision;

    return SettingsCard(
      title: 'Currency & Tax',
      description: 'Rates & rounding',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;

          final form = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSwitchTile(
                title: 'Enable Sales Tax',
                description: 'Automatically apply tax to all transactions',
                value: currencyTax.taxEnabled,
                onChanged: (v) => onChanged(currencyTax.copyWith(taxEnabled: v)),
                bordered: true,
              ),
              SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SettingsDropdown<int>(
                      label: 'Decimal Precision',
                      value: precision,
                      options: _precisionOptions,
                      labelBuilder: (v) => '$v Place${v == 1 ? '' : 's'} (${'0.' + '0' * v})',
                      onChanged: (v) => onChanged(currencyTax.copyWith(decimalPrecision: v)),
                    ),
                  ),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: SettingsNumberField(
                      label: 'Tax Rate (%)',
                      value: currencyTax.taxPercent,
                      suffix: '%',
                      onChanged: (v) => onChanged(currencyTax.copyWith(taxPercent: v.toDouble())),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsSwitchTile(
                title: 'Tax Inclusive Pricing',
                description: 'Display shelf prices with tax already included',
                value: currencyTax.pricesIncludeTax,
                onChanged: (v) => onChanged(currencyTax.copyWith(pricesIncludeTax: v)),
                bordered: true,
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsDropdown<String>(
                label: 'Currency',
                value: currencyTax.currency,
                options: _currencies,
                labelBuilder: (v) => v,
                onChanged: (v) => onChanged(currencyTax.copyWith(currency: v)),
              ),
            ],
          );

          final preview = _TaxEnginePreview(
            basePrice: _samplePrice,
            taxPercent: currencyTax.taxPercent,
            taxAmount: tax.toDouble(),
            total: total,
            precision: precision,
            currencySymbol: currencyTax.currencySymbol,
          );

          if (isNarrow) {
            return Column(
              children: [
                form,
                SizedBox(height: AppSpacing.lg),
                preview,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: form),
              SizedBox(width: AppSpacing.lg),
              Expanded(flex: 2, child: preview),
            ],
          );
        },
      ),
    );
  }
}

class _TaxEnginePreview extends StatelessWidget {
  final double basePrice;
  final double taxPercent;
  final double taxAmount;
  final double total;
  final int precision;
  final String currencySymbol;

  const _TaxEnginePreview({
    required this.basePrice,
    required this.taxPercent,
    required this.taxAmount,
    required this.total,
    required this.precision,
    required this.currencySymbol,
  });

  String _fmt(double v) => v.toStringAsFixed(precision);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TAX ENGINE PREVIEW',
            style: AppTextStyles.labelCaps
          ),
          SizedBox(height: AppSpacing.md),
          _row(context, 'Base Price', '$currencySymbol ${_fmt(basePrice)}'),
          _row(context, 'Sales Tax (${taxPercent.toStringAsFixed(2)}%)', '$currencySymbol ${_fmt(taxAmount)}'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(height: 1, color: context.colors.onPrimary.withOpacity(0.2)),
          ),
          _row(context, 'Grand Total', '$currencySymbol ${_fmt(total)}', emphasize: true),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.onPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: AppIconSize.sm, color: context.colors.onPrimary),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'These calculations use the regional rounding rule: Standard Nearest-Neighbor (Half Up).',
                    style: AppTextStyles.bodySm.copyWith(color: context.colors.onPrimary.withOpacity(0.9)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (emphasize ? AppTextStyles.bodyMd : AppTextStyles.bodySm).copyWith(
              color: context.colors.onPrimary.withOpacity(emphasize ? 1 : 0.85),
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: (emphasize ? AppTextStyles.headlineSm : AppTextStyles.dataMono).copyWith(
              color: context.colors.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
