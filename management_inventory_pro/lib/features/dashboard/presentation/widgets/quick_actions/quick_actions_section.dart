import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../data/models/quick_action.dart';
import 'quick_action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.onActionTap,
  });

  final void Function(QuickAction) onActionTap;

  static List<QuickAction> get _quickActions => const [
        QuickAction(
          id: 'new_sale',
          title: 'New Sale',
          description: 'Process a direct sale transaction',
          icon: Icons.shopping_cart_outlined,
          iconColor: AppColors.primary,
          iconBackground: AppColors.primaryFixed,
        ),
        QuickAction(
          id: 'new_stock_entry',
          title: 'New Stock Entry',
          description: 'Log arrival of new shipments',
          icon: Icons.move_to_inbox_outlined,
          iconColor: AppColors.success,
          iconBackground: AppColors.successContainer,
        ),
        QuickAction(
          id: 'add_product',
          title: 'Add Product',
          description: 'Register a new SKU in catalog',
          icon: Icons.add_box_outlined,
          iconColor: AppColors.onWarningContainer,
          iconBackground: AppColors.warningContainer,
        ),
        QuickAction(
          id: 'view_inventory',
          title: 'View Inventory',
          description: 'Full stock list & stocktaking',
          icon: Icons.inventory_2_outlined,
          iconColor: AppColors.secondary,
          iconBackground: AppColors.secondaryContainer,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width is very narrow (like < 600), stack them 2x2. Otherwise, keep them in a row.
        final bool isNarrow = constraints.maxWidth < 700;
        final double spacing = 12.0;

        if (isNarrow) {
          // Calculate width for 2-column layout
          final double cardWidth = (constraints.maxWidth - spacing) / 2;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: _quickActions
                .map(
                  (action) => SizedBox(
                    width: cardWidth,
                    child: QuickActionCard(
                      action: action,
                      onTap: () => onActionTap(action),
                    ),
                  ),
                )
                .toList(),
          );
        }

        // Standard 4-column row layout
        return Row(
          children: _quickActions
              .map(
                (action) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: action == _quickActions.last ? 0 : spacing,
                    ),
                    child: QuickActionCard(
                      action: action,
                      onTap: () => onActionTap(action),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
