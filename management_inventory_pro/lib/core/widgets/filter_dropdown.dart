import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'dropdown_item.dart';

/// Compact filter chip/trigger that opens a popup menu of [DropdownItem]s.
///
/// Refactor notes (responsive_rules.md):
/// - Removed `flutter_screenutil`; all sizing now comes from `AppSpacing` /
///   `AppRadius` / `AppIconSize` constants.
/// - Swapped ad-hoc `theme.colorScheme` / `theme.textTheme` lookups for the
///   shared `AppColors` / `AppTextStyles` design tokens so this matches the
///   rest of the design system instead of drifting from Material defaults.
/// - The trigger label is now capped with `ConstrainedBox` + wrapped in a
///   `Tooltip`, so a long selected-item name truncates with ellipsis
///   instead of pushing the trigger wider than the layout can afford.
class FilterDropdown<T> extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.icon,
    required this.label,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.onAdd,
    this.onDelete,
    this.addLabel,
    this.maxTriggerWidth = 220,
  });

  final IconData icon;
  final String label;

  final List<DropdownItem<T>> items;
  final DropdownItem<T>? selectedItem;

  final ValueChanged<DropdownItem<T>?> onChanged;

  final VoidCallback? onAdd;
  final ValueChanged<DropdownItem<T>>? onDelete;

  final String? addLabel;

  /// Caps how wide the trigger chip can grow before its label ellipsizes.
  final double maxTriggerWidth;

  @override
  Widget build(BuildContext context) {
    final active = selectedItem != null;

    return PopupMenuButton<_MenuAction<T>>(
      tooltip: '',
      offset: Offset(0, AppSpacing.xl + AppSpacing.lg),
      elevation: 4,
      color: AppColors.surface,
      constraints: BoxConstraints(
        minWidth: 180,
        maxWidth: 320,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      onSelected: (action) {
        switch (action.type) {
          case _MenuActionType.clear:
            onChanged(null);
          case _MenuActionType.select:
            onChanged(action.item);
          case _MenuActionType.add:
            onAdd?.call();
          case _MenuActionType.delete:
            if (action.item != null) {
              onDelete?.call(action.item!);
            }
        }
      },
      itemBuilder: (context) {
        return [
          _menuItem(
            context,
            text: 'All $label',
            icon: Icons.apps_rounded,
            selected: !active,
            action: const _MenuAction.clear(),
          ),
          if (items.isNotEmpty) const PopupMenuDivider(height: 1),
          ...items.map(
            (item) => _menuItem(
              context,
              text: item.label,
              icon: icon,
              selected: selectedItem == item,
              deletable: onDelete != null,
              action: _MenuAction.select(item),
            ),
          ),
          if (onAdd != null) ...[
            const PopupMenuDivider(height: 1),
            _menuItem(
              context,
              text: addLabel ?? 'Add',
              icon: Icons.add_circle_outline_rounded,
              isAdd: true,
              action: const _MenuAction.add(),
            ),
          ],
        ];
      },
      child: _DropdownTrigger(
        icon: icon,
        label: label,
        selected: selectedItem?.label,
        active: active,
        maxWidth: maxTriggerWidth,
      ),
    );
  }

  PopupMenuItem<_MenuAction<T>> _menuItem(
    BuildContext context, {
    required String text,
    required IconData icon,
    required _MenuAction<T> action,
    bool selected = false,
    bool isAdd = false,
    bool deletable = false,
  }) {
    final color = isAdd
        ? AppColors.secondary
        : selected
            ? AppColors.primary
            : AppColors.onSurface;

    return PopupMenuItem<_MenuAction<T>>(
      value: action,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg - AppSpacing.xxs),
      child: Row(
        children: [
          Container(
            width: AppIconSize.xl,
            height: AppIconSize.xl,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryContainer.withOpacity(0.15)
                  : isAdd
                      ? AppColors.secondaryContainer.withOpacity(0.5)
                      : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.standard),
            ),
            child: Icon(icon, size: AppIconSize.xs, color: color),
          ),
          SizedBox(width: AppSpacing.sm + AppSpacing.xxs),
          Expanded(
            child: Tooltip(
              message: text,
              waitDuration: const Duration(milliseconds: 500),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm.copyWith(
                  color: color,
                  fontWeight: selected || isAdd ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
          if (selected)
            Icon(Icons.check_rounded, size: AppIconSize.xs, color: AppColors.primary),
          if (deletable && action.item != null) ...[
            SizedBox(width: AppSpacing.md),
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.standard),
              onTap: () => Navigator.pop(context, _MenuAction.delete(action.item!)),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: AppIconSize.xs,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DropdownTrigger extends StatelessWidget {
  const _DropdownTrigger({
    required this.icon,
    required this.label,
    required this.selected,
    required this.active,
    required this.maxWidth,
  });

  final IconData icon;
  final String label;
  final String? selected;
  final bool active;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final displayText = selected ?? label;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: AnimatedContainer(
        duration: AppAnimation.fast,
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primaryContainer.withOpacity(0.15)
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.md + AppRadius.xs),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppIconSize.xs,
              color: active ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Tooltip(
                message: displayText,
                waitDuration: const Duration(milliseconds: 500),
                child: Text(
                  displayText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm.copyWith(
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.xs + AppSpacing.xxs),
            Icon(Icons.keyboard_arrow_down_rounded, size: AppIconSize.sm),
          ],
        ),
      ),
    );
  }
}

enum _MenuActionType { clear, select, add, delete }

class _MenuAction<T> {
  final _MenuActionType type;
  final DropdownItem<T>? item;

  const _MenuAction._(this.type, this.item);

  const _MenuAction.clear() : this._(_MenuActionType.clear, null);

  const _MenuAction.add() : this._(_MenuActionType.add, null);

  const _MenuAction.select(DropdownItem<T> item) : this._(_MenuActionType.select, item);

  const _MenuAction.delete(DropdownItem<T> item) : this._(_MenuActionType.delete, item);
}
