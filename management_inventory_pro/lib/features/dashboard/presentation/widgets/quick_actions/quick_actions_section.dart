import 'package:flutter/material.dart';

import '../../../data/models/quick_action.dart';
import 'quick_action_card.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  final List<QuickAction> actions;
  final void Function(QuickAction) onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions
          .map(
            (action) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == actions.last ? 0 : 12,
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
