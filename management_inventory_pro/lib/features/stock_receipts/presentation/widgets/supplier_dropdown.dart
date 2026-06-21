import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/cubit/suppliers_state.dart';
import '../../../../core/widgets/search_select_dropdown.dart';
import '../../../suppliers/presentation/cubit/suppliers_cubit.dart';
import '../../data/models/supplier_ref.dart';

/// Thin, supplier-specific wrapper around [SearchSelectDropdown].
///
/// All the overlay/search/list logic now lives in core; this just supplies
/// the supplier label, icon, and copy, plus the stub fallback list.
class SupplierDropdown extends StatelessWidget {
  final SupplierRef? selected;
  final bool? clear;
  final ValueChanged<SupplierRef?> onChanged;

  const SupplierDropdown({
    super.key,
    required this.onChanged,
    this.selected,  this.clear,
  });

  // Stub data used when no real supplier list is injected.
  static const _stubs = [
    SupplierRef(id: 'sup-1', name: 'Global Logistics Inc.'),
    SupplierRef(id: 'sup-2', name: 'Direct Goods Co.'),
    SupplierRef(id: 'sup-3', name: 'Summit Supplies'),
    SupplierRef(id: 'sup-4', name: 'Alpha Distribution'),
  ];

  @override
  Widget build(BuildContext context) {
   // final items = suppliers?.isNotEmpty == true ? suppliers! : _stubs;

    return BlocBuilder<SuppliersCubit, SuppliersState>(
      builder: (context, state) {
        if(state.status == SuppliersStatus.success ||state.suppliers.isNotEmpty||state.selectedSupplier!=null){
          print('SupplierDropdown selected = ${selected?.name}');
          return SearchSelectDropdown<SupplierRef>(
            selected: selected,
            items: state.suppliers.map((e) => SupplierRef.fromSupplierModel(e),).toList(),
            onChanged: onChanged,
            labelBuilder: (s) => s.name ?? '',
            itemIcon: Icons.business_outlined,
            placeholder: 'select supplier',
            searchHint: 'Search suppliers…',
            emptyText: 'No suppliers found.',
            clearable: clear??false,
          );
        }
        else{
          return SearchSelectDropdown<SupplierRef>(
            selected: selected,
            items: _stubs,
            onChanged: onChanged,
            labelBuilder: (s) => s.name ?? '',
            itemIcon: Icons.business_outlined,
            placeholder: 'select supplier',
            searchHint: 'Search suppliers…',
            emptyText: 'No suppliers found.',
          );
        }

      },
    );
  }
}
