import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PosSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const PosSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: AppColors.posCardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.posBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code_scanner_rounded, color: AppColors.posTextMuted, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    style: const TextStyle(fontSize: 14, color: AppColors.posTextPrimary),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Search Items or Scan Barcode (Ctrl+F)',
                      hintStyle: TextStyle(color: AppColors.posTextMuted, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.posSummaryBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 19, color: AppColors.posPrimary),
              SizedBox(width: 8),
              Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.posPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
