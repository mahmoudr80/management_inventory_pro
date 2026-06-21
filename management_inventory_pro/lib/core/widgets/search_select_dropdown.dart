import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_decoration.dart';
import '../theme/app_text_styles.dart';

/// A generic searchable single-select dropdown.
///
/// Opens an overlay anchored under the trigger field, containing a search
/// box and a filtered list of [T] items. The widget knows nothing about
/// what [T] is — callers supply [labelBuilder] (how to display an item)
/// and optionally [searchTextBuilder] (what to match search text against,
/// defaults to [labelBuilder]).
///
/// Use this for any "search + pick one from a list" field: suppliers,
/// products, customers, warehouses, categories, etc. Just instantiate it
/// with the right type and builders instead of writing a new dropdown.
///
/// Example:
/// ```dart
/// SearchSelectDropdown<ProductRef>(
///   selected: selectedProduct,
///   items: products,
///   labelBuilder: (p) => p.name,
///   itemIcon: Icons.inventory_2_outlined,
///   placeholder: 'select product',
///   searchHint: 'Search products…',
///   emptyText: 'No products found.',
///   onChanged: (p) => setState(() => selectedProduct = p),
/// )
/// ```
class SearchSelectDropdown<T> extends StatefulWidget {
  final T? selected;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  /// How to display an item, both in the trigger field and in the list.
  final String Function(T item) labelBuilder;

  /// What text to filter against. Defaults to [labelBuilder] if omitted —
  /// override this if you want search to also match e.g. an SKU or id
  /// that isn't part of the visible label.
  final String Function(T item)? searchTextBuilder;

  final IconData itemIcon;
  final String placeholder;
  final String searchHint;
  final String emptyText;

  /// Whether an "x" appears next to a selected value to clear it.
  final bool clearable;

  final double panelWidth;
  final double panelMaxHeight;

  const SearchSelectDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.labelBuilder,
    this.selected,
    this.searchTextBuilder,
    this.itemIcon = Icons.list_alt_outlined,
    this.placeholder = 'Select an option',
    this.searchHint = 'Search…',
    this.emptyText = 'No results found.',
    this.clearable = true,
    this.panelWidth = 320,
    this.panelMaxHeight = 260,
  });

  @override
  State<SearchSelectDropdown<T>> createState() =>
      _SearchSelectDropdownState<T>();
}

class _SearchSelectDropdownState<T> extends State<SearchSelectDropdown<T>> {
  final _layerLink = LayerLink();
  final _searchCtrl = TextEditingController();
  OverlayEntry? _overlay;
  bool _open = false;

  String Function(T) get _searchText =>
      widget.searchTextBuilder ?? widget.labelBuilder;

  List<T> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items
        .where((item) => _searchText(item).toLowerCase().contains(q))
        .toList();
  }

  // ── Overlay ────────────────────────────────────────────────────────────

  void _openDropdown() {
    if (_open) return;
    _open = true;
    _searchCtrl.clear();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                color: Colors.transparent,
                child: _DropdownPanel<T>(
                  searchCtrl: _searchCtrl,
                  filtered: _filtered,
                  onSelect: _select,
                  onSearchChanged: () => _overlay?.markNeedsBuild(),
                  labelBuilder: widget.labelBuilder,
                  itemIcon: widget.itemIcon,
                  searchHint: widget.searchHint,
                  emptyText: widget.emptyText,
                  width: widget.panelWidth,
                  maxHeight: widget.panelMaxHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
    setState(() {});
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    _open = false;
    setState(() {});
  }

  void _select(T? item) {
    widget.onChanged(item);
    _closeDropdown();
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _overlay?.remove();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    print('Selected item: $selected');
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _open ? _closeDropdown : _openDropdown,
        child: Container(
          height: 46.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: _open ? AppColors.primary : AppColors.border,
              width: _open ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: selected == null
                    ? Text(
                        widget.placeholder,
                        style: AppTextStyles.bodyMd
                            .copyWith(color: AppColors.outline),
                      )
                    : Text(
                        widget.labelBuilder(selected),
                        style: AppTextStyles.bodyMd,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              if (selected != null && widget.clearable)
                GestureDetector(
                  onTap: () => _select(null),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Icon(Icons.close,
                        size: 16, color: AppColors.outline),
                  ),
                ),
              Icon(
                _open
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: AppColors.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dropdown panel ──────────────────────────────────────────────────────────

class _DropdownPanel<T> extends StatelessWidget {
  final TextEditingController searchCtrl;
  final List<T> filtered;
  final ValueChanged<T?> onSelect;
  final VoidCallback onSearchChanged;
  final String Function(T) labelBuilder;
  final IconData itemIcon;
  final String searchHint;
  final String emptyText;
  final double width;
  final double maxHeight;

  const _DropdownPanel({
    required this.searchCtrl,
    required this.filtered,
    required this.onSelect,
    required this.onSearchChanged,
    required this.labelBuilder,
    required this.itemIcon,
    required this.searchHint,
    required this.emptyText,
    required this.width,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      constraints: BoxConstraints(maxHeight: maxHeight.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search
          Padding(
            padding: EdgeInsets.all(8.w),
            child: TextField(
              controller: searchCtrl,
              autofocus: true,
              style: AppTextStyles.bodyMd,
              onChanged: (_) => onSearchChanged(),
              decoration: AppDecorations.inputField(
                hint: searchHint,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 16,
                  color: AppColors.outline,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          // Results
          Flexible(
            child: filtered.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      emptyText,
                      style: AppTextStyles.bodySm
                          .copyWith(color: AppColors.outline),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _DropdownOption<T>(
                      label: labelBuilder(filtered[i]),
                      icon: itemIcon,
                      onTap: () => onSelect(filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DropdownOption<T> extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _DropdownOption({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_DropdownOption<T>> createState() => _DropdownOptionState<T>();
}

class _DropdownOptionState<T> extends State<_DropdownOption<T>> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          color: _hovering
              ? AppColors.surfaceContainerLow
              : AppColors.surfaceContainerLowest,
          padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              Icon(widget.icon, size: 16, color: AppColors.outline),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTextStyles.bodyMd,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
