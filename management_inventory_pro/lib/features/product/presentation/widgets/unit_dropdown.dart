// lib/features/products/presentation/widgets/unit_dropdown.dart

import 'package:flutter/material.dart';
import '../../data/models/unit_model.dart';

typedef UnitChanged = void Function(String? id);

class UnitDropdownWidget extends StatefulWidget {
  final UnitChanged onChanged;
  const UnitDropdownWidget({super.key, required this.onChanged});

  @override
  State<UnitDropdownWidget> createState() => _UnitDropdownWidgetState();
}

class _UnitDropdownWidgetState extends State<UnitDropdownWidget> {
  final List<UnitModel> _units = [
    UnitModel(id: '1', name: 'Piece'),
    UnitModel(id: '2', name: 'Box'),
    UnitModel(id: '3', name: 'Kg'),
  ];

  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Unit'),
      initialValue: _selectedId,
      items: _units
          .map((u) => DropdownMenuItem(value: u.id, child: Text(u.name)))
          .toList(),
      onChanged: (value) {
        setState(() => _selectedId = value);
        widget.onChanged(value);
      },
    );
  }
}
