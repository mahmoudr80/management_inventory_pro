import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import '../../theme/settings_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import '../../../models/settings_model.dart';
import '../cards/settings_card.dart';
import '../fields/settings_switch_tile.dart';

/// "Appearance" card — density/animation/text-size toggles plus a simple
/// three-way theme preview picker (Light / Dark / System).
class AppearanceSection extends StatelessWidget {
  final AppearanceSettings appearance;
  final ValueChanged<AppearanceSettings> onChanged;

  const AppearanceSection({super.key, required this.appearance, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Appearance',
      description: 'Themes & layout',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Theme', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500)),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: ThemeModeOption.values
                .map((mode) => _ThemeSwatch(
                      mode: mode,
                      selected: appearance.themeMode == mode,
                      onTap: () => onChanged(appearance.copyWith(themeMode: mode)),
                    ))
                .toList(),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Compact Density',
            description: 'Tighten row height and padding across tables',
            value: appearance.compactDensity,
            onChanged: (v) => onChanged(appearance.copyWith(compactDensity: v)),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Animations',
            description: 'Enable transition and micro-interaction animations',
            value: appearance.animationsEnabled,
            onChanged: (v) => onChanged(appearance.copyWith(animationsEnabled: v)),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Large Text',
            description: 'Increase base font size for readability',
            value: appearance.largeText,
            onChanged: (v) => onChanged(appearance.copyWith(largeText: v)),
          ),
        ],
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  final ThemeModeOption mode;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeSwatch({required this.mode, required this.selected, required this.onTap});

  String get _label {
    switch (mode) {
      case ThemeModeOption.light:
        return 'Light';
      case ThemeModeOption.dark:
        return 'Dark';
      case ThemeModeOption.system:
        return 'System';
    }
  }

  IconData get _icon {
    switch (mode) {
      case ThemeModeOption.light:
        return Icons.light_mode_outlined;
      case ThemeModeOption.dark:
        return Icons.dark_mode_outlined;
      case ThemeModeOption.system:
        return Icons.desktop_windows_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected
              ? context.settingsColors.primaryContainer.withOpacity(0.12)
              : context.settingsColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? context.colors.primary : context.colors.outlineVariant),
        ),
        child: Column(
          children: [
            Icon(_icon, color: selected ? context.colors.primary : context.settingsColors.onSurfaceVariant),
            SizedBox(height: AppSpacing.xs),
            Text(
              _label,
              style: AppTextStyles.bodySm.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? context.colors.primary : context.settingsColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
