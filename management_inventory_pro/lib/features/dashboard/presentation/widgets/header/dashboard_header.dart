import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';

import 'dashboard_actions.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.onRefresh,
    required this.onExport,
    required this.isLoading,
  });

  final VoidCallback onRefresh;
  final VoidCallback onExport;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(title: 'Dashboard',subtitle: 'Welcome back. Here\'s an overview of today\'s business performance.',
        actions: [     DashboardActions(
          onRefresh: onRefresh,
          onExport: onExport,
          isLoading: isLoading,
        ),],),
        Text(
          dateStr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );

  }
}
