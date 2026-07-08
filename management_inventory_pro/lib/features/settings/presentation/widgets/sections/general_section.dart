import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';

import '../../../models/settings_model.dart';
import '../cards/settings_card.dart';
import '../fields/settings_dropdown.dart';
import '../fields/settings_text_field.dart';

const _businessTypes = [
  'Electronics Retail',
  'Grocery & Supermarket',
  'Fashion & Apparel',
  'Pharmacy',
  'Hardware & Tools',
  'General Retail',
];

const _timezones = [
  'Africa/Cairo',
  'Africa/Casablanca',
  'Asia/Riyadh',
  'Asia/Dubai',
  'Europe/London',
  'UTC',
];

const _languages = ['English', 'Arabic', 'French'];
const _dateFormats = ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'];
const _timeFormats = ['12-hour', '24-hour'];

/// "General" card — store identity and regional defaults that affect
/// every other screen in the app (locale, timezone, formats).
class GeneralSection extends StatelessWidget {
  final GeneralSettings general;
  final ValueChanged<GeneralSettings> onChanged;

  const GeneralSection({super.key, required this.general, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'General',
      description: 'Localization & regional defaults',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SettingsTextField(
                  label: 'Store Name',
                  initialValue: general.storeName,
                  onChanged: (v) => onChanged(general.copyWith(storeName: v)),
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: SettingsDropdown<String>(
                  label: 'Business Type',
                  value: general.businessType,
                  options: _businessTypes,
                  labelBuilder: (v) => v,
                  onChanged: (v) => onChanged(general.copyWith(businessType: v)),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SettingsDropdown<String>(
                  label: 'Timezone',
                  value: general.timezone,
                  options: _timezones,
                  labelBuilder: (v) => v,
                  onChanged: (v) => onChanged(general.copyWith(timezone: v)),
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: SettingsDropdown<String>(
                  label: 'Language',
                  value: general.language,
                  options: _languages,
                  labelBuilder: (v) => v,
                  onChanged: (v) => onChanged(general.copyWith(language: v)),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SettingsDropdown<String>(
                  label: 'Date Format',
                  value: general.dateFormat,
                  options: _dateFormats,
                  labelBuilder: (v) => v,
                  onChanged: (v) => onChanged(general.copyWith(dateFormat: v)),
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: SettingsDropdown<String>(
                  label: 'Time Format',
                  value: general.timeFormat,
                  options: _timeFormats,
                  labelBuilder: (v) => v,
                  onChanged: (v) => onChanged(general.copyWith(timeFormat: v)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
