import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/components/status_chip.dart';
import 'package:management_inventory_pro/core/dialogs/app_confirm_dialog.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/marginCard.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/product_section_card.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/notes_section.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/pricing_section.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/product_image_section.dart';

import '../cubit/edit_product_cubit.dart';
import 'inventory_read_only_section.dart';
import 'product_information_section.dart';
import 'product_read_only_info_card.dart';

/// Edit Product form.
///
/// Opens fully pre-filled from [product] (no empty form — see the
/// initState below), lets the user change master-data fields only, and
/// pops with the updated [ProductModel] on success so the caller
/// (Product List) can refresh — same pop-with-result contract
/// AddProductForm already uses for Add Product.
class EditProductForm extends StatefulWidget {
  const EditProductForm({super.key, required this.product});

  final ProductModel product;

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _barcodeController;
  late TextEditingController _costPriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _minStockController;
  late TextEditingController _noteController;

  int? _selectedCategoryId;
  int? _selectedUnitId;
  String? _imageUrl;

  bool _isSaving = false;

  static String _formatNumber(double value) {
    return value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p.name);
    _skuController = TextEditingController(text: p.sku);
    _barcodeController = TextEditingController(text: p.barcode ?? '');
    _costPriceController = TextEditingController(text: _formatNumber(p.costPrice));
    _sellingPriceController =
        TextEditingController(text: _formatNumber(p.sellingPrice));
    _minStockController = TextEditingController(text: _formatNumber(p.minStock));
    _noteController = TextEditingController(text: p.note ?? '');
    _selectedCategoryId = p.categoryId;
    _selectedUnitId = p.unitId;
    _imageUrl = p.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _minStockController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double get _cost => double.tryParse(_costPriceController.text) ?? 0;
  double get _sell => double.tryParse(_sellingPriceController.text) ?? 0;
  double get _minStock => double.tryParse(_minStockController.text) ?? 0;

  double? get _marginPercent {
    if (_sell <= 0) return null;
    return ((_sell - _cost) / _sell) * 100;
  }

  /// True once any editable field diverges from the original product —
  /// drives the unsaved-changes confirmation on close.
  bool get _isDirty {
    final p = widget.product;
    return _nameController.text.trim() != p.name ||
        _skuController.text.trim() != p.sku ||
        _barcodeController.text.trim() != (p.barcode ?? '') ||
        _selectedCategoryId != p.categoryId ||
        _selectedUnitId != p.unitId ||
        _cost != p.costPrice ||
        _sell != p.sellingPrice ||
        _minStock != p.minStock ||
        _noteController.text.trim() != (p.note ?? '') ||
        _imageUrl != p.imageUrl;
  }

  Future<void> _handleClose(BuildContext context) async {
    if (!_isDirty) {
      Navigator.of(context).pop();
      return;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: 'Discard changes?',
        message:
            'You have unsaved changes to this product. Are you sure you want to discard them?',
        confirmText: 'Discard',
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.warning,
        iconBackgroundColor: AppColors.warningContainer,
        onConfirm: () {},
      ),
    );

    if (discard == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _submit(BuildContext context) {
    if (_isSaving) return;
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedCategoryId == null) {
      AppSnackBar.showError(context, message: 'Please, select category');
      return;
    }
    if (_selectedUnitId == null) {
      AppSnackBar.showError(context, message: 'Please, select unit');
      return;
    }

    setState(() => _isSaving = true);

    final p = widget.product;

    // Master-data-only update. id, createdAt, and currentStock are
    // carried over from the original product completely untouched —
    // Edit Product must never move inventory or rewrite identity/history.
    final updatedProduct = ProductModel(
      id: p.id,
      sku: _skuController.text.trim(),
      name: _nameController.text.trim(),
      category: p.category,
      status: p.status,
      statusText: p.statusText,
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      categoryId: _selectedCategoryId!,
      unitId: _selectedUnitId!,
      costPrice: _cost,
      sellingPrice: _sell,
      minStock: _minStock,
      imageUrl: _imageUrl,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      createdAt: p.createdAt,
      updatedAt: DateTime.now().toString(),
      currentStock: p.currentStock,
      unit: p.unit,
    );

    context.read<EditProductCubit>().updateProduct(updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProductCubit, EditProductState>(
      listener: (context, state) {
        if (_isSaving && !state.isSaving) {
          setState(() => _isSaving = false);
        }

        if (state.updatedProduct != null && !state.isSaving) {
          AppSnackBar.showSuccess(
            context,
            message: '${state.updatedProduct!.name} updated successfully',
          );
          Navigator.of(context).pop(state.updatedProduct);
        } else if (state.skuError != null) {
          AppSnackBar.showError(context, message: state.skuError!);
        } else if (state.barcodeError != null) {
          AppSnackBar.showError(context, message: state.barcodeError!);
        } else if (state.error != null) {
          AppSnackBar.showError(context, message: state.error!);
        }
      },
      child: PopScope(
        canPop: !_isDirty,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          await _handleClose(context);
        },
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: BlocBuilder<EditProductCubit, EditProductState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final bool isNarrow = constraints.maxWidth < 750;

                  final Widget formSections = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProductInformationSection(
                        nameController: _nameController,
                        skuController: _skuController,
                        barcodeController: _barcodeController,
                        categories: state.categories,
                        units: state.units,
                        selectedCategoryId: _selectedCategoryId,
                        selectedUnitId: _selectedUnitId,
                        onCategoryChanged: (id) =>
                            setState(() => _selectedCategoryId = id),
                        onUnitChanged: (id) =>
                            setState(() => _selectedUnitId = id),
                      ),
                      PricingSection(
                        costPriceController: _costPriceController,
                        sellingPriceController: _sellingPriceController,
                        marginCard: MarginCard(
                          sell: _sell,
                          cost: _cost,
                          marginPercent: _marginPercent,
                        ),
                      ),
                      InventoryReadOnlySection(
                        currentStock: widget.product.currentStock,
                        unitLabel: widget.product.unit,
                        minStockController: _minStockController,
                      ),
                      ProductSectionCard(
                        icon: Icons.photo_outlined,
                        title: 'Product image',
                        children: [
                          ImagePickerWidget(
                            initialImageUrl: widget.product.imageUrl,
                            onImagePicked: (url) => setState(() => _imageUrl = url),
                          ),
                        ],
                      ),
                      NotesSection(noteController: _noteController),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => _handleClose(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: _isSaving ? null : () => _submit(context),
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save_rounded, size: 18),
                            label: Text(_isSaving ? 'Saving…' : 'Save changes'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  );

                  final Widget infoPanel = ProductReadOnlyInfoCard(
                    id: widget.product.id,
                    createdAt: widget.product.createdAt,
                    currentStock: widget.product.currentStock,
                    statusText: widget.product.statusText ?? 'inactive',
                    status: widget.product.status ?? StatusType.inStock,
                  );

                  if (isNarrow) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          infoPanel,
                          const SizedBox(height: 16),
                          formSections,
                        ],
                      ),
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(child: formSections),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(width: 280, child: infoPanel),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
