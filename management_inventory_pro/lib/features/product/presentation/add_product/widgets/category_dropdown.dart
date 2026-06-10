import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/cubit/add_product_cubit.dart';

import '../../../../category/data/models/category_model.dart';

typedef CategoryChanged = void Function(String? id);

class CategoryDropdownWidget extends StatefulWidget {
  final CategoryChanged onChanged;

  const CategoryDropdownWidget({super.key, required this.onChanged});

  @override
  State<CategoryDropdownWidget> createState() => _CategoryDropdownWidgetState();
}

class _CategoryDropdownWidgetState extends State<CategoryDropdownWidget> {
  final List<CategoryModel> _categories = [
    CategoryModel(id: 1, name: 'Generic'),
    CategoryModel(id: 2, name: 'Driniking'),
    CategoryModel(id: 3, name: '-'),
  ];

  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductCubit,AddProductState>(
      builder: (context, state) {
        if(state.categories.isNotEmpty){
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Category'),
            value: _selectedId,
            items: state.categories
                .map((c) =>
                DropdownMenuItem(value: c.id.toString(), child: Text(c.name)))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedId = value);
              widget.onChanged(value);
            },
          );
        }
        else{
          ///to do add feature 'create category'
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Category'),
            value: _selectedId,
            items: _categories
                .map((c) =>
                DropdownMenuItem(value: c.id.toString(), child: Text(c.name)))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedId = value);
              widget.onChanged(value);
            },
          );
        }

      },
    );
  }
}
