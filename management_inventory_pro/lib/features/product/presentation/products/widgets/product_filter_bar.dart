import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/category/presentation/cubit/category_cubit.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/category_filter_dropdown.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/product_view_toggle.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/unit_filter_dropdown.dart';
import 'package:management_inventory_pro/features/unit/presentation/cubit/unit_cubit.dart';
import '../../../../../core/dialogs/app_confirm_dialog.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/product_cubit.dart';
import 'product_search_bar.dart';
import 'product_view_type.dart';

class ProductFilterBar extends StatefulWidget {
  final CategoryCubit categoryCubit;
  final UnitCubit unitCubit;

  const ProductFilterBar({
    super.key,
    required this.categoryCubit,
    required this.unitCubit,
  });

  @override
  State<ProductFilterBar> createState() => _ProductFilterBarState();
}

class _ProductFilterBarState extends State<ProductFilterBar> {
  Future<void> _confirmDelete({
    required BuildContext context,
    required String title,
    required String itemName,
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: title,
        message:
            'Are you sure you want to delete "$itemName"? This action cannot be undone.',
        confirmText: 'Delete',
        icon: Icons.delete_outline,
        iconColor: AppColors.error,
        iconBackgroundColor: AppColors.errorContainer,
        onConfirm: () {},
      ),
    );

    if (confirmed == true) {
      onConfirm();

      final productState = context.read<ProductCubit>().state;
      if (productState is ProductSuccess &&
          (productState.selectedCategory == itemName ||
              productState.selectedUnit == itemName)) {
        context.read<ProductCubit>().clearFilters();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.categoryCubit.state is! GetCategorySuccess) {
      widget.categoryCubit.getCategories();
    }
    if (widget.unitCubit.state is! GetUnitSuccess) {
      widget.unitCubit.getUnits();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, productState) {
        final selCat = productState is ProductSuccess
            ? productState.selectedCategory
            : null;
        final selUnit = productState is ProductSuccess
            ? productState.selectedUnit
            : null;
        final isFiltered = selCat != null || selUnit != null;
        final viewType = productState is ProductSuccess
            ? productState.viewType
            : ProductViewType.list;

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth < 650;

            final children = [
              Expanded(
                child: ProductSearchBar(onChanged: (query) =>
                    context.read<ProductCubit>().searchProducts),
              ),
              _BarLabel(),
              CategoryFilterDropdown(
                categoryCubit: widget.categoryCubit,
                selCat: selCat,
              ),
              UnitFilterDropdown(unitCubit: widget.unitCubit, selUnit: selUnit),
              if (isFiltered)
                _ActiveBadge(
                  label: selCat ?? selUnit!,
                  onClear: () => context.read<ProductCubit>().clearFilters(),
                ),
            ];

            if (isNarrow) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: children,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ProductViewToggle(
                          selected: viewType,
                          onChanged: (type) =>
                              context.read<ProductCubit>().changeViewType(type),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _BarLabel(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ProductSearchBar(onChanged: (query) =>
                    context.read<ProductCubit>().searchProducts(query)),
                  ),
                  const SizedBox(width: 14),
                  CategoryFilterDropdown(
                    categoryCubit: widget.categoryCubit,
                    selCat: selCat,
                  ),
                  const SizedBox(width: 10),
                  UnitFilterDropdown(unitCubit: widget.unitCubit, selUnit: selUnit),
                  if (isFiltered) ...[
                    const SizedBox(width: 12),
                    _ActiveBadge(
                      label: selCat ?? selUnit!,
                      onClear: () => context.read<ProductCubit>().clearFilters(),
                    ),
                  ],
                  const SizedBox(width: 14),
                  ProductViewToggle(
                    selected: viewType,
                    onChanged: (type) =>
                        context.read<ProductCubit>().changeViewType(type),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BarLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.tune_rounded,
          size: 15,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Text(
          'Filter',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const _ActiveBadge({required this.label, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.close_rounded,
              size: 13,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
