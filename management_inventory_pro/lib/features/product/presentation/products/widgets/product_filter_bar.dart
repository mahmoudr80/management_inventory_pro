  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
  import 'package:management_inventory_pro/features/category/presentation/cubit/category_cubit.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/category_filter_dropdown.dart';
import 'package:management_inventory_pro/features/product/presentation/products/widgets/unit_filter_dropdown.dart';
  import 'package:management_inventory_pro/features/unit/presentation/cubit/unit_cubit.dart';

  import '../../../../../core/dialogs/app_confirm_dialog.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../category/presentation/add_category_dialog.dart';
  import '../../../../unit/presentation/add_unit_dialog.dart';
  import '../cubit/product_cubit.dart';
  import 'custom_drop_down.dart';

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
        builder: (ctx) =>AppConfirmDialog(
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

        // If the deleted item was the active filter, clear it so the
        // product list doesn't keep filtering on something that no longer exists.
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
      // Pull categories & units directly from the database
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
          final selCat = productState is ProductSuccess ? productState.selectedCategory : null;
          final selUnit = productState is ProductSuccess ? productState.selectedUnit : null;
          final isFiltered = selCat != null || selUnit != null;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _BarLabel(),
                SizedBox(width: 14.w),
                CategoryFilterDropdown(categoryCubit: widget.categoryCubit,selCat:selCat ,),
                SizedBox(width: 10.w),
                UnitFilterDropdown(unitCubit: widget.unitCubit,selUnit:selUnit ,),

                if (isFiltered) ...[
                  SizedBox(width: 12.w),
                  _ActiveBadge(
                    label: selCat ?? selUnit!,
                    onClear: () => context.read<ProductCubit>().clearFilters(),
                  ),
                ],
              ],
            ),
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
          Icon(Icons.tune_rounded, size: 15.r, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: 5.w),
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

  // ── Active filter badge ───────────────────────────────────────────────────────

  class _ActiveBadge extends StatelessWidget {
    final String label;
    final VoidCallback onClear;

    const _ActiveBadge({required this.label, required this.onClear});

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: theme.colorScheme.primary.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 12.r, color: theme.colorScheme.primary),
            SizedBox(width: 5.w),
            Text(label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close_rounded, size: 13.r, color: theme.colorScheme.primary),
            ),
          ],
        ),
      );
    }
  }