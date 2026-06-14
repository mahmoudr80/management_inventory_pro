import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dialogs/dialog_utils.dart';
import '../../../../../core/utils/app_snackBar.dart';
import '../../../../category/presentation/add_category_dialog.dart';
import '../../../../category/presentation/cubit/category_cubit.dart';
import '../cubit/product_cubit.dart';
import 'custom_drop_down.dart';

class CategoryFilterDropdown extends StatelessWidget {
  const CategoryFilterDropdown({super.key, required this.categoryCubit, this.selCat});
final CategoryCubit categoryCubit;
final String ?selCat;

  Future<void> _openAddCategory(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: categoryCubit,
        child: const AddCategoryDialog(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      bloc: categoryCubit,
      listener: (context, state) {
        if (state is CategoryFailure) {
          AppSnackBar.showError(context, message: state.message,duration:2000 );
        } else if (state is CategoryDeleteSuccess) {
          AppSnackBar.showSuccess(context, message: 'Category deleted successfully');
        }
      },
      child: BlocBuilder<CategoryCubit, CategoryState>(
        bloc: categoryCubit,
        builder: (context, catState) {
          final categories = switch (catState) {
            GetCategorySuccess(categories: final list) =>
                list.map((c) => DropdownItem(id: c.id, name: c.name)).toList(),
            _ => <DropdownItem>[],
          };
          return CustomDropDown(
            icon: Icons.category_outlined,
            label: 'Category',
            selectedValue: selCat,
            items: categories,
            onSelect: (val) => val == null
                ? context.read<ProductCubit>().clearFilters()
                : context.read<ProductCubit>().filterByCategory(val),
            onAddNew: () => _openAddCategory(context),
            addLabel: 'New category',
            onDelete: (id) {
              final item = categories.firstWhere((c) => c.id == id);
              showDeleteConfirmation(
                context: context,
                title: 'Delete category',
                itemName: item.name,
                onConfirm: () => categoryCubit.deleteCategory(id),
              );
            },
          );
        },
      ),
    );
  }
}
