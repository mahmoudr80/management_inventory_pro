import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dropdown_item.dart';

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
  });

  final IconData icon;
  final String label;

  final List<DropdownItem<T>> items;
  final DropdownItem<T>? selectedItem;

  final ValueChanged<DropdownItem<T>?> onChanged;

  final VoidCallback? onAdd;
  final ValueChanged<DropdownItem<T>>? onDelete;

  final String? addLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = selectedItem != null;

    return PopupMenuButton<_MenuAction<T>>(
      tooltip: '',
      offset: Offset(0, 40.h),
      elevation: 4,
      color: theme.colorScheme.surface,
      constraints: BoxConstraints(minWidth: 180.w.clamp(150, 220)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(120),
        ),
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
            theme: theme,
            text: 'All $label',
            icon: Icons.apps_rounded,
            selected: !active,
            action: const _MenuAction.clear(),
          ),

          if (items.isNotEmpty)
            const PopupMenuDivider(height: 1),

          ...items.map(
                (item) => _menuItem(
              context,
              theme: theme,
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
              theme: theme,
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
      ),
    );
  }

  PopupMenuItem<_MenuAction<T>> _menuItem(
      BuildContext context, {
        required ThemeData theme,
        required String text,
        required IconData icon,
        required _MenuAction<T> action,
        bool selected = false,
        bool isAdd = false,
        bool deletable = false,
      }) {
    final color = isAdd
        ? theme.colorScheme.secondary
        : selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return PopupMenuItem<_MenuAction<T>>(
      value: action,
      height: 40.h.clamp(36, 48),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primaryContainer
                  : isAdd
                  ? theme.colorScheme.secondaryContainer.withAlpha(120)
                  : theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 14.r, color: color),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight:
                selected || isAdd ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),

          if (selected)
            Icon(
              Icons.check_rounded,
              size: 14.r,
              color: theme.colorScheme.primary,
            ),

          if (deletable && action.item != null) ...[
            SizedBox(width: 12.w),
            InkWell(
              borderRadius: BorderRadius.circular(6.r),
              onTap: () {
                Navigator.pop(
                  context,
                  _MenuAction.delete(action.item!),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(2.r),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 14,
                ),
              ),
            ),
          ]
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
  });

  final IconData icon;
  final String label;
  final String? selected;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 36.h.clamp(32, 42),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: active
            ? theme.colorScheme.primaryContainer.withAlpha(180)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: active
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.r,
            color: active
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 8.w),
          Text(
            selected ?? label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 6.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 16.r,
          ),
        ],
      ),
    );
  }
}

enum _MenuActionType {
  clear,
  select,
  add,
  delete,
}

class _MenuAction<T> {
  final _MenuActionType type;
  final DropdownItem<T>? item;

  const _MenuAction._(this.type, this.item);

  const _MenuAction.clear() : this._(_MenuActionType.clear, null);

  const _MenuAction.add() : this._(_MenuActionType.add, null);

  const _MenuAction.select(DropdownItem<T> item)
      : this._(_MenuActionType.select, item);

  const _MenuAction.delete(DropdownItem<T> item)
      : this._(_MenuActionType.delete, item);
}