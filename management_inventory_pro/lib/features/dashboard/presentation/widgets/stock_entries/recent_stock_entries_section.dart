import 'package:flutter/material.dart';
import '../../../data/models/recent_stock_entry.dart';
import '../common/dashboard_card.dart';
import '../common/loading_card.dart';
import '../common/section_header.dart';
import 'recent_stock_entries_table.dart';

class RecentStockEntriesSection extends StatelessWidget {
  const RecentStockEntriesSection({
    super.key,
    required this.entries,
    required this.isLoading,
    required this.onSelectEntry,
  });

  final List<RecentStockEntryRef> entries;
  final bool isLoading;
  final void Function(RecentStockEntryRef) onSelectEntry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LoadingCard(height: 300);

    return DashboardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SectionHeader(
              title: 'Recent Stock Entries',
              trailing: IconButton(
                icon: const Icon(Icons.more_horiz, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          RecentStockEntriesTable(entries: entries, onSelectEntry: onSelectEntry),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
