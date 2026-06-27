import 'package:flutter/material.dart';

import '../../../data/models/recent_stock_entry.dart';
import '../common/empty_state.dart';
import 'recent_stock_entry_row.dart';

class RecentStockEntriesTable extends StatelessWidget {
  const RecentStockEntriesTable({
    super.key,
    required this.entries,
    required this.onSelectEntry,
  });

  final List<RecentStockEntry> entries;
  final void Function(RecentStockEntry) onSelectEntry;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const EmptyState(
        message: 'No stock entries found.',
        icon: Icons.move_to_inbox_outlined,
      );
    }

    final theme = Theme.of(context);
    return Column(
      children: [
        _TableHeader(theme: theme),
        ...entries.take(8).map(
              (e) => RecentStockEntryRow(
                entry: e,
                onTap: () => onSelectEntry(e),
              ),
            ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    const s = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.08,
    );
    final c = theme.colorScheme.onSurfaceVariant;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('RECEIPT ID', style: s.copyWith(color: c)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('SUPPLIER', style: s.copyWith(color: c)),
            ),
          ),
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('TOTAL COST',
                  textAlign: TextAlign.right, style: s.copyWith(color: c)),
            ),
          ),
          SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('STATUS',
                  textAlign: TextAlign.center, style: s.copyWith(color: c)),
            ),
          ),
        ],
      ),
    );
  }
}
