import 'package:flutter/material.dart';
import 'product_view_type.dart';

/// Compact List/Grid segmented toggle, placed beside the filter dropdowns.
///
/// This is a pure, stateless presentation widget — it takes the currently
/// selected [ProductViewType] and reports changes via [onChanged]. It does
/// not know about the Cubit at all, which keeps it trivially reusable and
/// testable (Single Responsibility: "render + report a choice", nothing
/// else).
class ProductViewToggle extends StatelessWidget {
  const ProductViewToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ProductViewType selected;
  final ValueChanged<ProductViewType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.view_list_rounded,
            tooltip: 'List View',
            isSelected: selected == ProductViewType.list,
            onTap: () => onChanged(ProductViewType.list),
          ),
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            tooltip: 'Grid View',
            isSelected: selected == ProductViewType.grid,
            onTap: () => onChanged(ProductViewType.grid),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            width: 32,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
