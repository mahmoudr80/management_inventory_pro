import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import '../../../data/models/settings_model.dart';
import '../cards/logo_upload_card.dart';
import '../cards/settings_card.dart';
import '../fields/settings_text_field.dart';

/// "Store Information" card — branding and contact details that appear on
/// receipts, invoices, and the storefront-facing parts of the app.
class StoreInformationSection extends StatelessWidget {
  final StoreInfoSettings storeInfo;
  final ValueChanged<StoreInfoSettings> onChanged;

  const StoreInformationSection({
    super.key,
    required this.storeInfo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Store Information',
      description: 'Branding & contact',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.lg,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              LogoUploadCard(logoPath: storeInfo.logoPath),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 280),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SettingsTextField(
                              label: 'Primary Email',
                              initialValue: storeInfo.email,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (v) => onChanged(storeInfo.copyWith(email: v)),
                            ),
                          ),
                          SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: SettingsTextField(
                              label: 'Contact Number',
                              initialValue: storeInfo.phone,
                              keyboardType: TextInputType.phone,
                              onChanged: (v) => onChanged(storeInfo.copyWith(phone: v)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg),
                      SettingsTextField(
                        label: 'Tax Identification Number (VAT/GST)',
                        initialValue: storeInfo.taxNumber,
                        onChanged: (v) => onChanged(storeInfo.copyWith(taxNumber: v)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SettingsTextField(
                  label: 'Address',
                  initialValue: storeInfo.address,
                  onChanged: (v) => onChanged(storeInfo.copyWith(address: v)),
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: SettingsTextField(
                  label: 'Website',
                  initialValue: storeInfo.website,
                  keyboardType: TextInputType.url,
                  onChanged: (v) => onChanged(storeInfo.copyWith(website: v)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
