import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/components/page_header.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/supplier_ref.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/respository/stock_entry_repository.dart';
import 'package:management_inventory_pro/features/suppliers/data/repository/supplier_repository.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/cubit/suppliers_cubit.dart';
import '../../../../core/dialogs/dialog_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackBar.dart';
import '../../data/models/stock_entry_model.dart';
import '../cubit/stock_entry_cubit.dart';
import '../widgets/filter/stock_entry_filter_bar.dart';
import '../widgets/kpi/stock_entry_kpi_row.dart';
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
    // Load on first build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockEntryCubit>().loadEntries();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  Future<StockEntryModel?> _openNewEntry() async {
   return await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) =>  BlocProvider(
  create: (context) => StockEntryCubit(getIt<StockEntryRepository>()),
  child: NewStockEntryScreen(),
)),
    );
  }

  void _openEditEntry(StockEntryModel entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>  BlocProvider.value(
          value: context.read<StockEntryCubit>(),
          child: NewStockEntryScreen(existingEntry: entry,),
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
      onConfirm: () => context.read<StockEntryCubit>().deleteEntry(entry.id),
    );
  }

  SupplierRef? selectedSupplier;

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
        backgroundColor: AppColors.background,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:  16,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              // KPI cards
              BlocBuilder<StockEntryCubit, StockEntryState>(
                buildWhen: (p, c) => p.summary != c.summary || p.loadStatus != c.loadStatus,
                builder: (_, state) => StockEntryKpiRow(
                  summary: state.summary,
                  isLoading: state.loadStatus == StockEntryLoadStatus.loading,
                ),
              ),
              SizedBox(height: 20.h),

              // Search + filter bar

              BlocBuilder<StockEntryCubit, StockEntryState>(
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
                        context
                            .read<StockEntryCubit>()
                            .applyFilter(selectedSupplier: supplier,
                          supplierId: supplier?.id,
                          clearSupplier: supplier == null,);
                    },
                    onFilterDateRange: (dr) => context
                        .read<StockEntryCubit>()
                        .applyFilter(dateRange: dr, clearDate: dr == null),
                    onClearFilters: () => context.read<StockEntryCubit>().clearFilters(),
                  );
                },
              ),
              SizedBox(height: 16.h),
              // Table / empty / loading
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
                              .copyWith(color: AppColors.error),
                        ),
                      );
                    }
                    if (state.entries.isEmpty) {
                      return StockEntryEmptyState(onAddEntry: _openNewEntry);
                    }
                    return StockEntryTable(
                      entries: state.entries,
                      totalCount: state.totalCount,
                      currentPage: state.currentPage,
                      pageSize: state.pageSize,
                      isLoadingMore:
                          state.loadStatus == StockEntryLoadStatus.loading &&
                              state.entries.isNotEmpty,
                      onEdit: _openEditEntry,
                      onDelete: _confirmDelete,
                      onLoadMore: () =>
                          context.read<StockEntryCubit>().loadMoreEntries(),
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
    return  PageHeader(title: 'Stock Receipts Ledger',subtitle: 'Stock Receipts Ledger',
    actions: [
      ElevatedButton.icon(
        onPressed: () async {
          final entry = await _openNewEntry();
          if(entry!=null){
            if(mounted){
              context.read<StockEntryCubit>().clearFilters();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        icon: const Icon(Icons.add, size: 18),
        label: Text('Record Receipt', style: AppTextStyles.buttonText),
      ),
    ],);

  }
}
