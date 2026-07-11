import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/unit/data/models/unit_model.dart';

/// Plain, Cubit-agnostic unit picker — see [CategorySelectDropdown] for
/// why this isn't wired directly to UnitCubit the way Add Product's
/// UnitDropdownWidget is.
class UnitSelectDropdown extends StatelessWidget {
  const UnitSelectDropdown({
    super.key,
    required this.units,
    required this.selectedId,
    required this.onChanged,
  });

  final List<UnitModel> units;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final validValue = units.any((u) => u.id == selectedId) ? selectedId : null;

    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(labelText: 'Unit *'),
      initialValue: validValue,
      items: units
          .map((u) => DropdownMenuItem(value: u.id, child: Text(u.name)))
          .toList(),
      validator: (v) => v == null ? 'Required' : null,
      onChanged: onChanged,
    );
  }
}
