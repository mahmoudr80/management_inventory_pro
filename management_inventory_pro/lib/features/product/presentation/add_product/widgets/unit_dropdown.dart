
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../unit/data/models/unit_model.dart';
import '../cubit/add_product_cubit.dart';

typedef UnitChanged = void Function(String? id);

class UnitDropdownWidget extends StatefulWidget {
  final UnitChanged onChanged;
  const UnitDropdownWidget({super.key, required this.onChanged});

  @override
  State<UnitDropdownWidget> createState() => _UnitDropdownWidgetState();
}

class _UnitDropdownWidgetState extends State<UnitDropdownWidget> {
  final List<UnitModel> _units = [
    UnitModel(id: 1, name: '-', symbol: ''),
    UnitModel(id: 2, name: '-', symbol: ''),
    UnitModel(id: 3, name: '-', symbol: ''),
  ];

  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductCubit,AddProductState>(
        builder: (context, state) {
          if(state.units.isNotEmpty){
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Unit'),
              initialValue: _selectedId,
              items: state.units
                  .map((u) => DropdownMenuItem(value: u.id.toString(), child: Text(u.name)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedId = value);
                widget.onChanged(value);
              },
            );
          }
          else{
            /// to do add feature 'create unit'
            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Unit'),
              initialValue: _selectedId,
              items: _units
                  .map((u) => DropdownMenuItem(value: u.id.toString(), child: Text(u.name)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedId = value);
                widget.onChanged(value);
              },
            );
          }

        });
  }
}
