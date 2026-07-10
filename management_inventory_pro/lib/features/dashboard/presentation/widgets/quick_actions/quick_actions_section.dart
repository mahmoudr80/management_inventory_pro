import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme_extension.dart';
import '../../theme/dashboard_theme_extension.dart';
import '../../../data/models/quick_action.dart';
import 'quick_action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.onActionTap,
  });

  final void Function(QuickAction) onActionTap;

  List<QuickAction> _quickActions(BuildContext context) {
    final coreColors = context.colors;
    final dashColors = context.dashboardColors;
    return [
      QuickAction(
        id: 'new_sale',
        title: 'New Sale',
        description: 'Process a direct sale transaction',
        icon: Icons.shopping_cart_outlined,
        iconColor: coreColors.primary,
        iconBackground: dashColors.primaryContainer,
      ),
      QuickAction(
        id: 'new_stock_entry',
        title: 'New Stock Entry',
        description: 'Log arrival of new shipments',
        icon: Icons.move_to_inbox_outlined,
        iconColor: coreColors.success,
        iconBackground: dashColors.successContainer,
      ),
      QuickAction(
        id: 'add_product',
        title: 'Add Product',
        description: 'Register a new SKU in catalog',
        icon: Icons.add_box_outlined,
        iconColor: dashColors.onWarningContainer,
        iconBackground: dashColors.warningContainer,
      ),
      QuickAction(
        id: 'view_inventory',
        title: 'View Inventory',
        description: 'Full stock list & stocktaking',
        icon: Icons.inventory_2_outlined,
        iconColor: coreColors.secondary,
        iconBackground: dashColors.secondaryContainer,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final quickActions = _quickActions(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 700;
        final double spacing = 12.0;

        if (isNarrow) {
          final double cardWidth = (constraints.maxWidth - spacing) / 2;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: quickActions
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

        return Row(
          children: quickActions
              .map(
                (action) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == quickActions.last ? 0 : spacing,
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