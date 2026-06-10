
import 'package:flutter/material.dart';

import '../../../product/data/models/category_model.dart';

typedef CategoryChanged = void Function(String? id);

class CategoryDropdownWidget extends StatefulWidget {
  final CategoryChanged onChanged;
  const CategoryDropdownWidget({super.key, required this.onChanged});

  @override
  State<CategoryDropdownWidget> createState() => _CategoryDropdownWidgetState();
}

class _CategoryDropdownWidgetState extends State<CategoryDropdownWidget> {
  final List<CategoryModel> _categories = [
    CategoryModel(id: 1, name: 'Electronics'),
    CategoryModel(id: 2, name: 'Clothing'),
    CategoryModel(id: 3, name: 'Food'),
  ];

  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Category'),
      value: _selectedId,
      items: _categories
          .map((c) => DropdownMenuItem(value: c.id.toString(), child: Text(c.name)))
          .toList(),
      onChanged: (value) {
        setState(() => _selectedId = value);
        widget.onChanged(value);
      },
    );
  }
}
