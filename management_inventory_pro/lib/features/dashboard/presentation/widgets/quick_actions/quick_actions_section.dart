import 'package:flutter/material.dart';

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
  iconColor: Color(0xFF0041C8),
  iconBackground: Color(0xFFDCE1FF),
  ),
  QuickAction(
  id: 'new_stock_entry',
  title: 'New Stock Entry',
  description: 'Log arrival of new shipments',
  icon: Icons.move_to_inbox_outlined,
  iconColor: Color(0xFF1B6E3C),
  iconBackground: Color(0xFFD6F4E3),
  ),
  QuickAction(
  id: 'add_product',
  title: 'Add Product',
  description: 'Register a new SKU in catalog',
  icon: Icons.add_box_outlined,
  iconColor: Color(0xFF7B3C00),
  iconBackground: Color(0xFFFFE4CC),
  ),
  QuickAction(
  id: 'view_inventory',
  title: 'View Inventory',
  description: 'Full stock list & stocktaking',
  icon: Icons.inventory_2_outlined,
  iconColor: Color(0xFF505F76),
  iconBackground: Color(0xFFD0E1FB),
  ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _quickActions
          .map(
            (action) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == _quickActions.last ? 0 : 12,
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
  }
}
