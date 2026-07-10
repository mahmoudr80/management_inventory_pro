import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import '../../theme/settings_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import '../../../models/settings_model.dart';
import '../cards/settings_card.dart';
import '../common/settings_section_title.dart';
import '../fields/settings_dropdown.dart';
import '../fields/settings_number_field.dart';
import '../fields/settings_switch_tile.dart';

const _units = ['Piece', 'Kg', 'Liter', 'Box', 'Carton', 'Meter'];

/// "Inventory" card — stock control rules: threshold sliders on the left,
/// boolean toggles on the right, matching the two-column layout in the
/// reference design.
class InventorySettingsSection extends StatelessWidget {
  final InventorySettings inventory;
  final ValueChanged<InventorySettings> onChanged;

  const InventorySettingsSection({super.key, required this.inventory, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Inventory',
      description: 'Stock control rules',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;

          final thresholds = Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.settingsColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsSectionTitle(
                  label: 'STOCK THRESHOLDS',
                  caption: 'Global defaults for warning indicators.',
                ),
                SizedBox(height: AppSpacing.md),
                SettingsNumberField(
                  label: 'Low Stock Alert Level',
                  value: inventory.lowStockThreshold,
                  asSlider: true,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  suffix: 'Units',
                  badgeColor: context.colors.primary,
                  onChanged: (v) => onChanged(inventory.copyWith(lowStockThreshold: v.round())),
                ),
                SizedBox(height: AppSpacing.lg),
                SettingsNumberField(
                  label: 'Critical Stock Level',
                  value: inventory.criticalStockThreshold,
                  asSlider: true,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  suffix: 'Units',
                  badgeColor: context.colors.error,
                  badgeBackground: context.settingsColors.errorContainer,
                  onChanged: (v) => onChanged(inventory.copyWith(criticalStockThreshold: v.round())),
                ),
              ],
            ),
          );

          final toggles = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSwitchTile(
                title: 'Allow Negative Stock',
                description: 'Process sales even if SKU is at zero',
                value: inventory.allowNegativeStock,
                onChanged: (v) => onChanged(inventory.copyWith(allowNegativeStock: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsSwitchTile(
                title: 'Auto SKU Generation',
                description: 'Create unique keys for new products',
                value: inventory.autoSku,
                onChanged: (v) => onChanged(inventory.copyWith(autoSku: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsSwitchTile(
                title: 'Require Barcode',
                description: 'Block saving a product without a scanned barcode',
                value: inventory.requireBarcode,
                onChanged: (v) => onChanged(inventory.copyWith(requireBarcode: v)),
              ),
              SizedBox(height: AppSpacing.lg),
              SettingsSwitchTile(
                title: 'Enable Stock Alerts',
                description: 'Notify when items cross the low-stock threshold',
                value: inventory.enableStockAlerts,
                onChanged: (v) => onChanged(inventory.copyWith(enableStockAlerts: v)),
              ),
            ],
          );

          final layout = isNarrow
              ? Column(
                  children: [
                    thresholds,
                    SizedBox(height: AppSpacing.lg),
                    toggles,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: thresholds),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(child: toggles),
                  ],
                );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              layout,
              SizedBox(height: AppSpacing.lg),
              SettingsDropdown<String>(
                label: 'Default Unit',
                value: inventory.defaultUnit,
                options: _units,
                labelBuilder: (v) => v,
                onChanged: (v) => onChanged(inventory.copyWith(defaultUnit: v)),
              ),
            ],
          );
        },
      ),
    );
  }
}
