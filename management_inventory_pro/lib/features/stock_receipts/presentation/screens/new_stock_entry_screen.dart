import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_header.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_info_section.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_line_table.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/form/stock_entry_notes_section.dart';
import 'package:management_inventory_pro/features/suppliers/data/repository/supplier_repository.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/cubit/suppliers_cubit.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/dependency_injection/service_locator.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/app_snackBar.dart';
import '../../data/models/product_ref.dart';
import '../../data/models/stock_entry_line_model.dart';
import '../../data/models/stock_entry_model.dart';
import '../../data/models/stock_entry_status.dart';
import '../../data/models/supplier_ref.dart';
import '../cubit/stock_entry_cubit.dart';
import '../widgets/entry_summary_footer.dart';

enum StockEntryMode {
  create,
  edit,
  restock,
}

class NewStockEntryScreen extends StatefulWidget {
  final StockEntryModel? existingEntry;
  final ProductRef? initialProduct;
  final SupplierRef? initialSupplier;
  final StockEntryMode mode;

  const NewStockEntryScreen({
    super.key,
    this.existingEntry,
    this.initialProduct,
    this.initialSupplier,
    required this.mode,
  });

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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    switch (widget.mode) {
      case StockEntryMode.create:
        _receiptDate = DateTime.now();
        _lines = [];
        _receiptId = '';
        context.read<StockEntryCubit>().generateReceiptId().then((id) {
          if (mounted) setState(() => _receiptId = id);
        });
        break;

      case StockEntryMode.edit:
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
        break;

      case StockEntryMode.restock:
        _receiptDate = DateTime.now();
        _lines = [
          StockEntryLineModel(
            id: const Uuid().v4(),
            product: widget.initialProduct!,
            quantity: 1,
            unitCost: 0,
          ),
        ];
        _receiptId = '';
        context.read<StockEntryCubit>().generateReceiptId().then((id) {
          if (mounted) setState(() => _receiptId = id);
        });
        break;
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
  double get _subtotal => _lines.fold(0.0, (s, l) => s + l.lineTotal);

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lines.isEmpty) {
      AppSnackBar.showError(context, message: 'Add at least one product line.');
      return;
    }
    final now = DateTime.now();
    final entry = StockEntryModel(
      id: _receiptId,
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
      if (widget.mode == StockEntryMode.edit) {
        await context.read<StockEntryCubit>().updateEntry(entry);
      } else {
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
      backgroundColor: context.colors.background,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StockEntryHeader(
                      isEditMode: widget.mode == StockEntryMode.edit,
                      receiptId: _receiptId,
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 20),
                    StockEntryLineTable(
                      lines: _lines,
                      onLineChanged: _updateLine,
                      onRemoveLine: _removeLine,
                      onAddLine: _addEmptyLine,
                    ),
                    const SizedBox(height: 16),
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