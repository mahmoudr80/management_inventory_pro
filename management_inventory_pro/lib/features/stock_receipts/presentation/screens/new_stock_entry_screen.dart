import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_header.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_info_section.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_line_table.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_notes_section.dart';
import 'package:management_inventory_pro/features/suppliers/data/repository/supplier_repository.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/cubit/suppliers_cubit.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackBar.dart';
import '../../data/models/product_ref.dart';
import '../../data/models/stock_entry_line_model.dart';
import '../../data/models/stock_entry_model.dart';
import '../../data/models/stock_entry_status.dart';
import '../../data/models/supplier_ref.dart';
import '../cubit/stock_entry_cubit.dart';
import '../widgets/entry_summary_footer.dart';

class NewStockEntryScreen extends StatefulWidget {
  final StockEntryModel? existingEntry;

  const NewStockEntryScreen({super.key, this.existingEntry});

  @override
  State<NewStockEntryScreen> createState() => _NewStockEntryScreenState();
}

class _NewStockEntryScreenState extends State<NewStockEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  late String _receiptId;
  SupplierRef? _selectedSupplier;
  late DateTime _receiptDate;
  late List<StockEntryLineModel> _lines;

  bool _isEditMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.existingEntry != null;

    if (_isEditMode) {
      final e = widget.existingEntry!;
      _receiptId = e.id;
      _receiptDate = e.receiptDate;
      _lines = List.from(e.lines);
      _notesController.text = e.notes ?? '';
      if (e.supplier.id != null) {
        _selectedSupplier = SupplierRef(
          id: e.supplier.id!,
          name: e.supplier.name ?? '',
        );
      }
    } else {
      _receiptDate = DateTime.now();
      _lines = [];
      _receiptId = '';
      // Generate receipt ID from repository.
      context.read<StockEntryCubit>().generateReceiptId().then((id) {
        if (mounted) setState(() => _receiptId = id);
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addEmptyLine() {
    setState(() {
      ProductRef product = ProductRef(id: '', name: '');
      _lines.add(
        StockEntryLineModel(
          id: const Uuid().v4(),
          product: product,
          quantity: 1,
          unitCost: 0.0,
        ),
      );
    });
  }

  void _updateLine(int index, StockEntryLineModel updated) {
    setState(() => _lines[index] = updated);
  }

  void _removeLine(int index) {
    setState(() => _lines.removeAt(index));
  }

  int get _totalItems => _lines.fold(0, (s, l) => s + l.quantity);
  double get _subtotal => _lines.fold(0.0, (s, l) => s + l.lineTotal); //total cost

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lines.isEmpty) {
      AppSnackBar.showError(context, message: 'Add at least one product line.');
      return;
    }

    final now = DateTime.now();
    final entry = StockEntryModel(
      id: _receiptId,
      totalCost: _subtotal,
      totalQuantity: _totalItems.toDouble(),
      totalItems: _lines.length,
      supplier: SupplierRef(
        id: _selectedSupplier?.id,
        name: _selectedSupplier?.name,
      ),
      receiptDate: _receiptDate,
      lines: _lines,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      status: StockEntryStatus.verified,
      createdAt: widget.existingEntry?.createdAt ?? now,
      updatedAt: now,
    );

    setState(() => _isLoading = true);
    try {
      if (_isEditMode) {
        await context.read<StockEntryCubit>().updateEntry(entry);
      } else {
        print('${entry.id} - ${entry.status} -${entry.supplier.toString()} - ${entry.lines.length} -'
            ' ${entry.receiptDate.toString()} - totalQuantity: ${entry.totalQuantity.toString()}'
            ' - totalItems: ${entry.totalItems.toString()} - totalCost: ${entry.totalCost.toString()}'
            ' - products: ${entry.lines.map((e) => e.product.id.toString(),).toString()}'
            ' - products: ${entry.lines[0].product.id}');
        await context.read<StockEntryCubit>().addEntry(entry);
      }
      if (mounted) Navigator.of(context).pop(entry);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _receiptDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _receiptDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StockEntryHeader(
                      isEditMode: _isEditMode,
                      receiptId: _receiptId,
                    ),
                    SizedBox(height: 24.h),
                    BlocProvider(
                      create: (context) =>
                          SuppliersCubit(getIt<SupplierRepository>())
                            ..loadSuppliers(),
                      child: StockEntryInfoSection(
                        receiptDate: _receiptDate,
                        selectedSupplier: _selectedSupplier,
                        onChanged: (s) => setState(() => _selectedSupplier = s),
                        onTap: _pickDate,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    StockEntryLineTable(
                      lines: _lines,
                      onLineChanged: (index, updated) =>
                          _updateLine(index, updated),
                      onRemoveLine: (index) => _removeLine(index),
                      onAddLine: () => _addEmptyLine(),
                    ),
                    SizedBox(height: 16.h),
                    StockEntryNotesSection(notesController: _notesController),
                  ],
                ),
              ),
            ),
            // Sticky footer
            EntrySummaryFooter(
              totalItems: _totalItems,
              subtotal: _subtotal,
              isLoading: _isLoading,
              onCancel: () => Navigator.of(context).pop(null),
              onSave: _save,
            ),
          ],
        ),
      ),
    );
  }
}
