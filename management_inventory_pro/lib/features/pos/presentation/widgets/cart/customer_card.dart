import 'package:flutter/material.dart';
import '../../theme/pos_theme_extension.dart';

class CustomerCard extends StatelessWidget {
  final String customerName;
  final String subtitle;
  final VoidCallback? onEdit;

  const CustomerCard({
    super.key,
    this.customerName = 'Guest Customer',
    this.subtitle = 'ADD TO LOYALTY PROGRAM',
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.posColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.posColors.summaryBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.person_add_alt_1_rounded, color: context.posColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  customerName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: context.posColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 0.4,
                    color: context.posColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              foregroundColor: context.posColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}