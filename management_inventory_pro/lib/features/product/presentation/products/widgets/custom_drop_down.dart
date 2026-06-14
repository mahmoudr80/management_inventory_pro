import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Represents a selectable item in [CustomDropDown], carrying both
/// the database id (used for deletion) and the display name.
class DropdownItem {
  final int id;
  final String name;

  const DropdownItem({required this.id, required this.name});
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.icon,
    required this.label,
    this.selectedValue,
    required this.items,
    required this.onSelect,
    required this.onAddNew,
    required this.addLabel,
    this.onDelete,
  });
  final IconData icon;
  final String label;
  final String? selectedValue;
  final List<DropdownItem> items;
  final ValueChanged<String?> onSelect;
  final VoidCallback onAddNew;
  final String addLabel;

  /// Called with the item's id when its delete icon is tapped.
  final ValueChanged<int>? onDelete;

  static const _clearSentinel = '__clear__';
  static const _addSentinel = '__add__';
  static const _deletePrefix = '__delete__:';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = selectedValue != null;
    final menuItems = <PopupMenuEntry<String>>[
      _buildMenuItem(
        context: context,
        value: _clearSentinel,
        icon: Icons.apps_rounded,
        text: 'All ${label}s',
        isSelected: !isActive,
        isAdd: false,
        theme: theme,
      ),
      if (items.isNotEmpty) const PopupMenuDivider(height: 1),
      for (final item in items)
        _buildMenuItem(
          context: context,
          value: item.name,
          icon: icon,
          isDeletable: true,
          itemId: item.id,
          text: item.name,
          isSelected: selectedValue == item.name,
          isAdd: false,
          theme: theme,
        ),
      const PopupMenuDivider(height: 1),
      _buildMenuItem(
        context: context,
        value: _addSentinel,
        icon: Icons.add_circle_outline_rounded,
        text: addLabel,
        isSelected: false,
        isAdd: true,
        theme: theme,
      ),
    ];

    return PopupMenuButton<String>(
      onSelected: (val) {
        if (val == _clearSentinel) {
          onSelect(null);
        } else if (val == _addSentinel) {
          onAddNew();
        } else if (val.startsWith(_deletePrefix)) {
          final id = int.parse(val.substring(_deletePrefix.length));
          onDelete?.call(id);
        } else {
          onSelect(val);
        }
      },
      itemBuilder: (_) => menuItems,
      offset: Offset(0, 40.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withAlpha(120),
        ),
      ),
      elevation: 4,
      color: theme.colorScheme.surface,
      constraints: BoxConstraints(minWidth: 180.w.clamp(150, 220)),
      tooltip: '',
      child: _DropdownTrigger(
        icon: icon,
        label: label,
        selectedValue: selectedValue,
        isActive: isActive,
        theme: theme,
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required BuildContext context,
    required String value,
    required IconData icon,
    required String text,
    required bool isSelected,
    bool? isDeletable,
    int? itemId,
    required bool isAdd,
    required ThemeData theme,
  }) {
    final color = isAdd
        ? theme.colorScheme.secondary
        : isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return PopupMenuItem<String>(
      value: value,
      height: 40.h.clamp(36, 48),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: isSelected
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
                fontWeight: isSelected || isAdd
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_rounded,
              size: 14.r,
              color: theme.colorScheme.primary,
            ),
          SizedBox(width: 20.w.clamp(15, 25)),
          (isDeletable ?? false) && itemId != null
              ? InkWell(
            borderRadius: BorderRadius.circular(6.r),
            onTap: () {
              // Close the menu, returning a "delete" sentinel
              // instead of selecting this item.
              Navigator.of(context).pop('$_deletePrefix$itemId');
            },
            child: Padding(
              padding: EdgeInsets.all(2.r),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 14.r,
                color: Colors.red,
              ),
            ),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _DropdownTrigger extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? selectedValue;
  final bool isActive;
  final ThemeData theme;

  const _DropdownTrigger({
    required this.icon, required this.label,
    required this.selectedValue,
    required this.isActive, required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      height: 36.h.clamp(32, 42),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primaryContainer.withAlpha(200)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isActive
              ? theme.colorScheme.primary.withAlpha(180)
              : theme.colorScheme.outlineVariant,
          width: isActive ? 1.5 : 1.0,
        ),
        boxShadow: isActive
            ? [BoxShadow(
            color: theme.colorScheme.primary.withAlpha(30),
            blurRadius: 6, offset: const Offset(0, 2))]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant),
          SizedBox(width: 7.w),
          Text(selectedValue ?? label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              )),
          SizedBox(width: 6.w),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16.r,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}