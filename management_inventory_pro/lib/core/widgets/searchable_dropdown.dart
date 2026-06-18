// import 'package:flutter/material.dart';
//
// class AppSearchableDropdown<T> extends StatefulWidget {
//   final T? selected;
//   final List<T> items;
//
//   final String Function(T item) labelBuilder;
//   final ValueChanged<T?> onChanged;
//
//   final String hint;
//   final String searchHint;
//
//   final IconData itemIcon;
//
//   const AppSearchableDropdown({
//     super.key,
//     this.selected,
//     required this.items,
//     required this.labelBuilder,
//     required this.onChanged,
//     required this.hint,
//     required this.searchHint,
//     required this.itemIcon,
//   });
//
//   @override
//   State<AppSearchableDropdown<T>> createState() =>
//       _AppSearchableDropdownState<T>();
// }
// class _AppSearchableDropdownState<T>
//     extends State<AppSearchableDropdown<T>> {
//   final _layerLink = LayerLink();
//   final _searchCtrl = TextEditingController();
//
//   OverlayEntry? _overlay;
//   bool _open = false;
// }