import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme_extension.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/components/app_card.dart';
import '../../../../../../core/components/status_chip.dart';
import '../../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onDelete;

  const ProductCard({super.key, required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(4),
            ),
            child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(product.imageUrl!),
                width: 40,
                height: 40,
                fit: BoxFit.scaleDown,
              ),
            )
                : Icon(
              Icons.inventory_2_outlined,
              color: context.colors.primary,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Tooltip(
                        message: product.name,
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyles.headlineSm.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(
                      label: product.statusText ?? 'inactive',
                      type: product.status ?? StatusType.inStock,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Tooltip(
                  message: product.sku,
                  child: Text(
                    product.sku,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.dataMono.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Category: ${product.category}',
                  child: Text(
                    'Category: ${product.category}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppTextStyles.bodySm.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.currentStock} units',
                style: AppTextStyles.dataMono.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: context.colors.error,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}