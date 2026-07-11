import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// A generic searchable single-select dropdown, styled to match the design
/// system's default surface/outline/primary palette.
///
/// Unlike a plain dropdown, this widget has a SINGLE control: the trigger
/// field itself becomes the search input when opened (readOnly toggles
/// off, autofocus kicks in). A 160ms blur delay avoids the tap-before-blur
/// race condition when picking an item.
///
/// The widget knows nothing about what [T] is — callers supply
/// [labelBuilder] (how to display an item) and optionally
/// [searchTextBuilder] (what to match search text against, defaults to
/// [labelBuilder]). Pass [subtitleBuilder] / [trailingBuilder] for a
/// richer two-line row like the product search results.
///
/// Refactor notes (responsive_rules.md):
/// - Removed `flutter_screenutil` (.h/.w/.r/.sp) and raw hex colors in
///   favor of `core/theme` tokens (`AppColors`, `AppTextStyles`,
///   `AppSpacing`, `AppRadius`) so this dropdown matches every other themed
///   component instead of hand-rolled styling.
/// - Result panel keeps a max-height + `Flexible`/`ListView` so long result
///   sets scroll instead of pushing the layout past the 600px minimum
///   window height.
/// - Every row label/subtitle/trailing value is capped at one line with
///   `TextOverflow.ellipsis`, and the primary label is wrapped in a
///   `Tooltip` so a truncated name can still be read on hover.
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
  State<SearchSelectDropdown<T>> createState() => _SearchSelectDropdownState<T>();
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

  static const double _fieldHeight = AppSize.textFieldHeight + 2;
  static const double _overlayGap = AppSpacing.xs;

  String Function(T) get _searchText => widget.searchTextBuilder ?? widget.labelBuilder;

  List<T> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items.where((item) => _searchText(item).toLowerCase().contains(q)).toList();
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
        offset: const Offset(0, _fieldHeight + _overlayGap),
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
    if (!_open) return;
    _collapseOverlay();
    if (!mounted) return;
    setState(() {
      _controller.text = widget.selected != null ? widget.labelBuilder(widget.selected as T) : '';
    });
  }

  void _select(T? item) {
    _collapseOverlay();
    // Set text from the item we just picked rather than widget.selected —
    // the parent hasn't rebuilt with the new selection yet, so
    // widget.selected is still stale at this point.
    setState(() {
      _controller.text = item != null ? widget.labelBuilder(item) : '';
    });
    _focusNode.unfocus();
    widget.onChanged(item);
  }

  void _onChanged(String value) {
    setState(() => _query = value);
    _overlay?.markNeedsBuild();
    // Rebuild with fresh filtered list.
    _showOverlay();
  }

  @override
  void initState() {
    super.initState();
    // Populate the field immediately if the widget is created with an
    // already-selected value (e.g. navigated in with `initialProduct` set,
    // as with dashboard "Restock" -> NewStockEntryScreen). Without this,
    // the controller stays empty until the user taps the field, because
    // only _openDropdown()/didUpdateWidget ever sync from widget.selected.
    if (widget.selected != null) {
      _controller.text = widget.labelBuilder(widget.selected as T);
    }
  }

  @override
  void didUpdateWidget(covariant SearchSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_open && widget.selected != oldWidget.selected) {
      _controller.text =
      widget.selected != null ? widget.labelBuilder(widget.selected as T) : '';
    }
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
          height: _fieldHeight,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: !_open,
            onTap: _open ? null : _openDropdown,
            onChanged: _onChanged,
            maxLines: 1,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.outline),
              prefixIcon: Icon(
                _open ? Icons.search : widget.itemIcon,
                size: AppIconSize.md,
                color: AppColors.outline,
              ),
              suffixIcon: selected != null && widget.clearable && !_open
                  ? IconButton(
                      icon: Icon(Icons.close, size: AppIconSize.md),
                      color: AppColors.outline,
                      onPressed: () => _select(null),
                    )
                  : Icon(
                      _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: AppIconSize.md,
                      color: AppColors.outline,
                    ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.primary, width: AppBorder.medium),
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
      constraints: BoxConstraints(maxHeight: maxHeight),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
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
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                emptyText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm,
              ),
            )
          else
            // Flexible + shrinkWrap keeps the list bounded by maxHeight and
            // lets it scroll internally instead of overflowing the overlay
            // when there are many results (per responsive_rules.md).
            Flexible(
              child: Scrollbar(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.outlineVariant),
                  itemBuilder: (_, i) => _DropdownOption<T>(
                    label: labelBuilder(filtered[i]),
                    subtitle: subtitleBuilder?.call(filtered[i]),
                    trailing: trailingBuilder?.call(filtered[i]),
                    icon: itemIcon,
                    onTap: () => onSelect(filtered[i]),
                  ),
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
      hoverColor: AppColors.surfaceContainer,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
        child: Row(
          children: [
            Icon(icon, size: AppIconSize.md, color: AppColors.primary),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: label,
                    waitDuration: const Duration(milliseconds: 500),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                    ),
                ],
              ),
            ),
            if (trailing != null && trailing!.isNotEmpty) ...[
              SizedBox(width: AppSpacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 90),
                child: Tooltip(
                  message: trailing!,
                  waitDuration: const Duration(milliseconds: 500),
                  child: Text(
                    trailing!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.dataMono.copyWith(fontWeight: FontWeight.w700),
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
