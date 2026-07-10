import 'package:flutter/material.dart';
import '../theme/pos_theme_extension.dart';

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
              color: context.posColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.posColors.border),
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
                Icon(Icons.qr_code_scanner_rounded, color: context.posColors.textMuted, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    style: TextStyle(fontSize: 14, color: context.posColors.textPrimary),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Search Items or Scan Barcode (Ctrl+F)',
                      hintStyle: TextStyle(color: context.posColors.textMuted, fontSize: 14),
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
            color: context.posColors.summaryBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune_rounded, size: 19, color: context.posColors.primary),
              const SizedBox(width: 8),
              Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: context.posColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}