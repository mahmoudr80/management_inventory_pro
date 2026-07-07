import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/components/app_card.dart';
import '../../../../../../core/components/status_chip.dart';
import '../../../data/models/product_model.dart';

/// Grid-card presentation of a [ProductModel].
class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onDelete;

  const ProductGridCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(product.imageUrl!),
                      width: double.infinity,
                      height: 90,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                : const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                    size: 36,
                  ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: product.name,
                  child: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                tooltip: 'Delete product',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: AppColors.error,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
          Tooltip(
            message: product.sku,
            child: Text(
              product.sku,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.dataMono.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Tooltip(
            message: 'Category: ${product.category}',
            child: Text(
              'Category: ${product.category}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm.copyWith(fontSize: 10),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusChip(
                label: product.statusText ?? 'inactive',
                type: product.status ?? StatusType.inStock,
              ),
              Text(
                '${product.currentStock} units',
                style: AppTextStyles.dataMono.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
