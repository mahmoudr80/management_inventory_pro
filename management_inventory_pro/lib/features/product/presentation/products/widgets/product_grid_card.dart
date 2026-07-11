import 'dart:io';

import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';
import 'package:management_inventory_pro/core/components/app_card.dart';
import 'package:management_inventory_pro/core/components/status_chip.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';

class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductGridCard({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
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
              color: context.colors.surfaceContainerLow,
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
                : Icon(
              Icons.inventory_2_outlined,
              color: context.colors.primary,
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
                tooltip: 'Edit product',
                icon: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: context.colors.primary,
                ),
                onPressed: onEdit,
              ),
              const SizedBox(width: 2),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                tooltip: 'Delete product',
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: context.colors.error,
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
                color: context.colors.primary,
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
