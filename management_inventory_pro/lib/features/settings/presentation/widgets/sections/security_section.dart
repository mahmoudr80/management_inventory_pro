import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import '../../theme/settings_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import 'package:management_inventory_pro/core/widgets/secondary_button.dart';
import '../../../models/settings_model.dart';
import '../cards/settings_card.dart';
import '../fields/settings_number_field.dart';
import '../fields/settings_switch_tile.dart';

/// "Users & Security" card — the signed-in user's role/session info plus
/// login behavior. Password change is a stub `onChangePassword` callback,
/// left for a real auth flow to wire up later.
class SecuritySection extends StatelessWidget {
  final SecuritySettings security;
  final ValueChanged<SecuritySettings> onChanged;
  final VoidCallback? onChangePassword;

  const SecuritySection({
    super.key,
    required this.security,
    required this.onChanged,
    this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Users & Security',
      description: 'Roles & permissions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.settingsColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: context.colors.primary,
                  child: Text(
                    security.currentUser.isNotEmpty ? security.currentUser[0] : '?',
                    style: AppTextStyles.bodyLg.copyWith(color: context.colors.onPrimary, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(security.currentUser, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700)),
                      Text(security.role, style: AppTextStyles.bodySm),
                    ],
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: SecondaryButton(
                    text: 'Change Password',
                    icon: Icons.lock_outline_rounded,
                    onPressed: onChangePassword ?? () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsSwitchTile(
            title: 'Remember Login',
            description: 'Stay signed in on this device between launches',
            value: security.rememberLogin,
            onChanged: (v) => onChanged(security.copyWith(rememberLogin: v)),
          ),
          SizedBox(height: AppSpacing.lg),
          SettingsNumberField(
            label: 'Session Timeout',
            value: security.sessionTimeoutMinutes,
            suffix: 'minutes',
            onChanged: (v) => onChanged(security.copyWith(sessionTimeoutMinutes: v.round())),
          ),
        ],
      ),
    );
  }
}
