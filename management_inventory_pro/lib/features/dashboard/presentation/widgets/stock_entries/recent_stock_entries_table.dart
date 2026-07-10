import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../data/models/recent_stock_entry.dart';
import '../common/empty_state.dart';
import 'recent_stock_entry_row.dart';

class RecentStockEntriesTable extends StatefulWidget {
  const RecentStockEntriesTable({
    super.key,
    required this.entries,
    required this.onSelectEntry,
  });

  final List<RecentStockEntryRef> entries;
  final void Function(RecentStockEntryRef) onSelectEntry;

  @override
  State<RecentStockEntriesTable> createState() => _RecentStockEntriesTableState();
}

class _RecentStockEntriesTableState extends State<RecentStockEntriesTable> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return const EmptyState(
        message: 'No stock entries found.',
        icon: Icons.move_to_inbox_outlined,
      );
    }

    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double minTableWidth = 500.0;
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Scrollbar(
            controller: _horizontalController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: SizedBox(
                  width: math.max(minTableWidth, constraints.maxWidth),
                  child: Column(
                    children: [
                      _TableHeader(theme: theme),
                      ...widget.entries.take(8).map(
                            (e) => RecentStockEntryRow(
                              entry: e,
                              onTap: () => widget.onSelectEntry(e),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Tooltip(
                message: 'RECEIPT ID',
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    'RECEIPT ID', style: s.copyWith(color: c)),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Tooltip(
              message: 'SUPPLIER',
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  'SUPPLIER', style: s.copyWith(color: c)),
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Tooltip(
              message: 'TOTAL COST',
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  'TOTAL COST',
                  textAlign: TextAlign.right, style: s.copyWith(color: c)),
            ),
          )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Tooltip(
                message: 'STATUS',
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    'STATUS',
                    textAlign: TextAlign.center, style: s.copyWith(color: c)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
