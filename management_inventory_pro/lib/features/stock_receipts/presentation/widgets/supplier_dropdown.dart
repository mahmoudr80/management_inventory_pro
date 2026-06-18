import 'package:flutter/material.dart';
import '../../../../core/widgets/search_select_dropdown.dart';
import '../../data/models/supplier_ref.dart';

/// Thin, supplier-specific wrapper around [SearchSelectDropdown].
///
/// All the overlay/search/list logic now lives in core; this just supplies
/// the supplier label, icon, and copy, plus the stub fallback list.
class SupplierDropdown extends StatelessWidget {
  final SupplierRef? selected;
  final List<SupplierRef>? suppliers;
  final ValueChanged<SupplierRef?> onChanged;

  const SupplierDropdown({
    super.key,
    required this.onChanged,
    this.selected,
    this.suppliers,
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
    final items = suppliers?.isNotEmpty == true ? suppliers! : _stubs;

    return SearchSelectDropdown<SupplierRef>(
      selected: selected,
      items: items,
      onChanged: onChanged,
      labelBuilder: (s) => s.name,
      itemIcon: Icons.business_outlined,
      placeholder: 'select supplier',
      searchHint: 'Search suppliers…',
      emptyText: 'No suppliers found.',
    );
  }
}
