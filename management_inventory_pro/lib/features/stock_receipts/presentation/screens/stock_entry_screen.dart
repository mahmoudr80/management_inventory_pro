import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/product_ref.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/supplier_ref.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/respository/stock_entry_repository.dart';
import '../../../../core/dialogs/dialog_utils.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackBar.dart';
import '../../../home/cubit/home_cubit.dart';
import '../../data/models/stock_entry_model.dart';
import '../cubit/stock_entry_cubit.dart';
import '../widgets/filter/stock_entry_filter_bar.dart';
import '../widgets/kpi/stock_entry_kpi_row.dart';
import '../widgets/pannel/stock_entry_details_panel.dart';
import '../widgets/states/stock_entry_empty_state.dart';
import '../widgets/table/stock_entry_table.dart';
import 'new_stock_entry_screen.dart';

class StockEntryScreen extends StatefulWidget {
  const StockEntryScreen({super.key});

  @override
  State<StockEntryScreen> createState() => _StockEntryScreenState();
}

class _StockEntryScreenState extends State<StockEntryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockEntryCubit>().loadEntries();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final homeState = context.read<HomeCubit>().state;

    if (homeState.action == PageAction.createStockEntry) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openNewEntry();
        context.read<HomeCubit>().clearAction();
      });
    } else if (homeState.action == PageAction.restock) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openNewEntry(mode: StockEntryMode.restock, product: homeState.restock);
        context.read<HomeCubit>().clearAction();
      });
    } else if (homeState.action == PageAction.selectStockEntry) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (homeState.selectEntry != null) {
          context.read<StockEntryCubit>().selectEntry(homeState.selectEntry!);
        }
        context.read<HomeCubit>().clearAction();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  Future<StockEntryModel?> _openNewEntry({
    ProductRef? product,
    StockEntryMode? mode,
    SupplierRef? initialSupplier,
  }) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => StockEntryCubit(getIt<StockEntryRepository>()),
          child: NewStockEntryScreen(
            mode: mode ?? StockEntryMode.create,
            initialProduct: product,
            initialSupplier: initialSupplier,
          ),
        ),
      ),
    );
  }

  void _openEditEntry(StockEntryModel entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<StockEntryCubit>(),
          child: NewStockEntryScreen(
            existingEntry: entry,
            mode: StockEntryMode.edit,
          ),
        ),
      ),
    );
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<void> _confirmDelete(StockEntryModel entry) async {
    await showDeleteConfirmation(
      context: context,
      title: 'Delete Receipt',
      itemName: entry.id,
      onConfirm: () {
        context.read<StockEntryCubit>().deleteEntry(entry.id);
        context.read<StockEntryCubit>().clearSelection();
      },
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockEntryCubit, StockEntryState>(
      listenWhen: (prev, curr) => prev.actionStatus != curr.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == StockEntryActionStatus.success) {
          AppSnackBar.showSuccess(context, message: 'Done');
          context.read<StockEntryCubit>().resetActionStatus();
        } else if (state.actionStatus == StockEntryActionStatus.failure) {
          AppSnackBar.showError(context, message: state.actionError ?? 'Error');
          context.read<StockEntryCubit>().resetActionStatus();
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),

              // ── KPI row ─────────────────────────────────────────────────
              LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isNarrow = constraints.maxWidth > 1000;
                    if(isNarrow){
                      return   BlocBuilder<StockEntryCubit, StockEntryState>(
                        buildWhen: (p, c) =>
                        p.summary != c.summary || p.loadStatus != c.loadStatus,
                        builder: (_, state) => StockEntryKpiRow(
                          summary: state.summary,
                          isLoading: state.loadStatus == StockEntryLoadStatus.loading,
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }
              ),

              // ── Filter bar ──────────────────────────────────────────────
              BlocBuilder<StockEntryCubit, StockEntryState>(
                buildWhen: (p, c) =>
                p.filter != c.filter ||
                    p.selectedSupplier != c.selectedSupplier,
                builder: (context, state) {
                  return StockEntryFilterBar(
                    selectedSupplier: state.selectedSupplier,
                    searchController: _searchController,
                    activeFilter: state.filter,
                    onSearch: (q) => context.read<StockEntryCubit>().search(q),
                    onFilterStatus: (s) async => await context
                        .read<StockEntryCubit>()
                        .applyFilter(status: s, clearStatus: s == null),
                    onFilterSupplier: (supplier) {
                      context.read<StockEntryCubit>().applyFilter(
                        selectedSupplier: supplier,
                        supplierId: supplier?.id,
                        clearSupplier: supplier == null,
                      );
                    },
                    onFilterDateRange: (dr) => context
                        .read<StockEntryCubit>()
                        .applyFilter(dateRange: dr, clearDate: dr == null),
                    onClearFilters: () =>
                        context.read<StockEntryCubit>().clearFilters(),
                  );
                },
              ),
              const SizedBox(height: 8),

              // ── Table + optional details panel ──────────────────────────
              Expanded(
                child: BlocBuilder<StockEntryCubit, StockEntryState>(
                  builder: (_, state) {
                    if (state.loadStatus == StockEntryLoadStatus.loading &&
                        state.entries.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.loadStatus == StockEntryLoadStatus.failure) {
                      return Center(
                        child: Text(
                          state.loadError ?? 'Something went wrong.',
                          style: AppTextStyles.bodyMd
                              .copyWith(color: context.colors.error),
                        ),
                      );
                    }

                    if (state.entries.isEmpty) {
                      return StockEntryEmptyState(onAddEntry: _openNewEntry);
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isNarrow = constraints.maxWidth < 1000;

                        final Widget tableWidget = StockEntryTable(
                          entries: state.entries,
                          selectedEntry: state.selectedEntry,
                          totalCount: state.totalCount,
                          currentPage: state.currentPage,
                          pageSize: state.pageSize,
                          isLoadingMore: state.loadStatus ==
                              StockEntryLoadStatus.loading &&
                              state.entries.isNotEmpty,
                          onSelect: (entry) => context
                              .read<StockEntryCubit>()
                              .selectEntry(entry),
                          onEdit: _openEditEntry,
                          onDelete: _confirmDelete,
                          onLoadMore: () =>
                              context.read<StockEntryCubit>().loadMoreEntries(),
                        );

                        if (isNarrow) {
                          return Stack(
                            children: [
                              tableWidget,
                              if (state.selectedEntry != null)
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  height: MediaQuery.of(context).size.height * 0.45,
                                  child: StockEntryDetailsPanel(
                                    entry: state.selectedEntry!,
                                  ),
                                ),
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 7,
                              child: tableWidget,
                            ),
                            if (state.selectedEntry != null) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: StockEntryDetailsPanel(
                                  entry: state.selectedEntry!,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return PageHeader(
      title: 'Stock Receipts Ledger',
      subtitle: 'Manage and monitor all inbound warehouse stock shipments.',
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            final entry = await _openNewEntry();
            if (entry != null && mounted) {
              context.read<StockEntryCubit>().clearFilters();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.add, size: 18),
          label: Text('Record Receipt', style: AppTextStyles.buttonText),
        ),
      ],
    );
  }
}