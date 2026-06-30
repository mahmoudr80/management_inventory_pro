import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A generic searchable single-select dropdown, styled to match the
/// ProductSearchSection look (white panel, EAEDFF header/hover, C3C5D9
/// borders, 0041C8 accent).
///
/// Unlike the old version, this widget has a SINGLE control: the trigger
/// field itself becomes the search input when opened (readOnly toggles
/// off, autofocus kicks in), the same pattern used by
/// SupplierSearchDropdown. A 160ms blur delay avoids the tap-before-blur
/// race condition when picking an item.
///
/// The widget knows nothing about what [T] is — callers supply
/// [labelBuilder] (how to display an item) and optionally
/// [searchTextBuilder] (what to match search text against, defaults to
/// [labelBuilder]). Pass [subtitleBuilder] / [trailingBuilder] for a
/// richer two-line row like the product search results.
///
/// Example:
/// ```dart
/// SearchSelectDropdown<ProductRef>(
///   selected: selectedProduct,
///   items: products,
///   labelBuilder: (p) => p.name,
///   searchTextBuilder: (p) => '${p.name} ${p.sku ?? ''}',
///   subtitleBuilder: (p) => p.sku ?? '',
///   itemIcon: Icons.inventory_2_outlined,
///   placeholder: 'Select product',
///   searchHint: 'Search products or SKU...',
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

  /// Optional secondary line shown under the label in the results list
  /// (e.g. category, SKU/barcode).
  final String Function(T item)? subtitleBuilder;

  /// Optional trailing text shown at the end of each row (e.g. stock qty).
  final String Function(T item)? trailingBuilder;

  final IconData itemIcon;
  final String placeholder;
  final String searchHint;
  final String emptyText;

  /// Whether an "x" appears next to a selected value to clear it.
  final bool clearable;

  final double panelMaxHeight;

  const SearchSelectDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.labelBuilder,
    this.selected,
    this.searchTextBuilder,
    this.subtitleBuilder,
    this.trailingBuilder,
    this.itemIcon = Icons.list_alt_outlined,
    this.placeholder = 'Select an option',
    this.searchHint = 'Search…',
    this.emptyText = 'No results found.',
    this.clearable = true,
    this.panelMaxHeight = 300,
  });

  @override
  State<SearchSelectDropdown<T>> createState() =>
      _SearchSelectDropdownState<T>();
}

class _SearchSelectDropdownState<T> extends State<SearchSelectDropdown<T>> {
  final _layerLink = LayerLink();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  // Shared TapRegion id: a tap anywhere in the field OR the overlay panel
  // counts as "inside". Only a tap outside both closes the dropdown, so
  // scrolling/tapping rows never gets mistaken for an outside tap the way
  // focus-loss detection did.
  final Object _groupId = Object();
  OverlayEntry? _overlay;
  bool _open = false;
  String _query = '';
  double _triggerWidth = 0;

  String Function(T) get _searchText =>
      widget.searchTextBuilder ?? widget.labelBuilder;

  List<T> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items
        .where((item) => _searchText(item).toLowerCase().contains(q))
        .toList();
  }

  // ── Overlay ────────────────────────────────────────────────────────────

  void _openDropdown() {
    if (_open) return;
    final renderBox = context.findRenderObject() as RenderBox;
    _triggerWidth = renderBox.size.width;
    setState(() {
      _open = true;
      _query = '';
      _controller.clear();
      if (widget.selected != null) {
        _controller.text = widget.labelBuilder(widget.selected as T);
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
    _focusNode.requestFocus();
    _showOverlay();
  }

  void _showOverlay() {
    _overlay?.remove();
    _overlay = OverlayEntry(
      builder: (_) => CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, 46.h + 4),
        child: TapRegion(
          groupId: _groupId,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: _triggerWidth,
              child: _DropdownPanel<T>(
                filtered: _filtered,
                onSelect: _select,
                labelBuilder: widget.labelBuilder,
                subtitleBuilder: widget.subtitleBuilder,
                trailingBuilder: widget.trailingBuilder,
                itemIcon: widget.itemIcon,
                emptyText: widget.emptyText,
                maxHeight: widget.panelMaxHeight,
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  /// Collapses the overlay only — does not touch the text field's content.
  void _collapseOverlay() {
    _overlay?.remove();
    _overlay = null;
    if (!mounted) return;
    setState(() => _open = false);
  }

  /// Closes the dropdown and resyncs the field text to the current
  /// [widget.selected] (or clears it). Used for cancel / outside-tap,
  /// where there's no pending selection update to wait for.
  void _closeDropdown() {
    _collapseOverlay();
    if (!mounted) return;
    setState(() {
      _controller.text =
          widget.selected != null ? widget.labelBuilder(widget.selected as T) : '';
    });
  }

  void _select(T? item) {
    widget.onChanged(item);
    _focusNode.unfocus();
    _collapseOverlay();
    // Set text from the item we just picked rather than widget.selected —
    // the parent hasn't rebuilt with the new selection yet, so
    // widget.selected is still stale at this point.
    setState(() {
      _controller.text = item != null ? widget.labelBuilder(item) : '';
    });
  }

  void _onChanged(String value) {
    setState(() => _query = value);
    _overlay?.markNeedsBuild();
    // Rebuild with fresh filtered list.
    _showOverlay();
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _overlay?.remove();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    return CompositedTransformTarget(
      link: _layerLink,
      child: TapRegion(
        groupId: _groupId,
        onTapOutside: (_) {
          if (_open) _closeDropdown();
        },
        child: SizedBox(
          height: 46.h,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: !_open,
            onTap: _open ? null : _openDropdown,
            onChanged: _onChanged,
            style: TextStyle(fontSize: 5.sp, color: const Color(0xFF131B2E)),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(fontSize: 5.sp, color: const Color(0xFF737688)),
              prefixIcon: Icon(
                _open ? Icons.search : widget.itemIcon,
                size: 28.r,
                color: const Color(0xFF737688),
              ),
              suffixIcon: selected != null && widget.clearable && !_open
                  ? IconButton(
                      icon: Icon(Icons.close, size: 28.r),
                      color: const Color(0xFF737688),
                      onPressed: () => _select(null),
                    )
                  : Icon(
                      _open
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 28.r,
                      color: const Color(0xFF737688),
                    ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFFC3C5D9)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFFC3C5D9)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF0041C8), width: 1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Dropdown panel ──────────────────────────────────────────────────────────

class _DropdownPanel<T> extends StatelessWidget {
  final List<T> filtered;
  final ValueChanged<T?> onSelect;
  final String Function(T) labelBuilder;
  final String Function(T item)? subtitleBuilder;
  final String Function(T item)? trailingBuilder;
  final IconData itemIcon;
  final String emptyText;
  final double maxHeight;

  const _DropdownPanel({
    required this.filtered,
    required this.onSelect,
    required this.labelBuilder,
    required this.subtitleBuilder,
    required this.trailingBuilder,
    required this.itemIcon,
    required this.emptyText,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFC3C5D9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (filtered.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                emptyText,
                style: TextStyle(fontSize: 5.sp, color: const Color(0xFF737688)),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Color(0xFFC3C5D9)),
                itemBuilder: (_, i) => _DropdownOption<T>(
                  label: labelBuilder(filtered[i]),
                  subtitle: subtitleBuilder?.call(filtered[i]),
                  trailing: trailingBuilder?.call(filtered[i]),
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

class _DropdownOption<T> extends StatelessWidget {
  final String label;
  final String? subtitle;
  final String? trailing;
  final IconData icon;
  final VoidCallback onTap;

  const _DropdownOption({
    required this.label,
    required this.subtitle,
    required this.trailing,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      canRequestFocus: false,
      hoverColor: const Color(0xFFEAEDFF),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(icon, size: 28.r, color: const Color(0xFF0041C8)),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF131B2E),
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 5.sp,
                        color: const Color(0xFF737688),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null && trailing!.isNotEmpty) ...[
              SizedBox(width: 2.w),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 70.w),
                child: Text(
                  trailing!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF131B2E),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
