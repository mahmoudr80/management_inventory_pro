import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';

/// Plain, Cubit-agnostic category picker.
///
/// Given a fixed [categories] list and the currently [selectedId], it
/// just reports changes via [onChanged]. Deliberately NOT wired directly
/// to CategoryCubit the way Add Product's CategoryDropdownWidget is —
/// that widget has no way to pre-select an existing value, which Edit
/// Product needs (the form must open pre-filled, never empty). A pure
/// presentation widget makes that trivial and is easy to reuse anywhere
/// else a category needs picking.
class CategorySelectDropdown extends StatelessWidget {
  const CategorySelectDropdown({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onChanged,
  });

  final List<CategoryModel> categories;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final validValue =
        categories.any((c) => c.id == selectedId) ? selectedId : null;

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: 'Category *'),
      initialValue: validValue,
      items: categories
          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
          .toList(),
      validator: (v) => v == null ? 'Required' : null,
      onChanged: onChanged,
    );
  }
}
