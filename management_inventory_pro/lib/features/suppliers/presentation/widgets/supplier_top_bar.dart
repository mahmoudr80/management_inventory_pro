import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SupplierTopBar extends StatelessWidget {
  const SupplierTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppColors.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo
          Text(
            'RetailFlow',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '/ Suppliers',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          // Search icon
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
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
            backgroundColor: AppColors.primaryFixedDim,
            child: Text(
              'A',
              style: AppTextStyles.labelCaps.copyWith(
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
