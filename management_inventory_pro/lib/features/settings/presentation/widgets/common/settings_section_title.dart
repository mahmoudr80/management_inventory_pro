import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

import '../../../../../core/theme/app_theme_extension.dart';

/// Small uppercase sub-heading used to break a [SettingsCard]'s body into
/// labeled groups (e.g. "Stock Thresholds" inside the Inventory card).
class SettingsSectionTitle extends StatelessWidget {
  final String label;
  final String? caption;

  const SettingsSectionTitle({super.key, required this.label, this.caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelCaps.copyWith(color: context.colors.textPrimary)),
          if (caption != null) ...[
            SizedBox(height: AppSpacing.xxs),
            Text(caption!, style: AppTextStyles.bodySm.copyWith(color: context.colors.info)),
          ],
        ],
      ),
    );
  }
}
