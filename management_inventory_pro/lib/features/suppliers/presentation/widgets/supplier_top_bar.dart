import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

class SupplierTopBar extends StatelessWidget {
  const SupplierTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: context.colors.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo
          Text(
            'RetailFlow',
            style: AppTextStyles.headlineSm.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '/ Suppliers',
            style: AppTextStyles.headlineSm.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          // Search icon
          IconButton(
            icon: Icon(
              Icons.search,
              size: 20,
              color: context.colors.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: context.colors.onSurfaceVariant,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: context.colors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          // Avatar
          CircleAvatar(
            radius: 17,
            backgroundColor: context.colors.primaryFixedDim,
            child: Text(
              'A',
              style: AppTextStyles.labelCaps.copyWith(
                color: context.colors.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}