import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/cubit/add_product_cubit.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/product_section_card.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/product_summary_panel.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/basic_information_section.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/inventory_section.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/notes_section.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/pricing_section.dart';
import 'package:management_inventory_pro/features/product/presentation/add_product/widgets/sections/product_image_section.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/components/status_chip.dart';
import '../../../data/models/product_model.dart';
import 'marginCard.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _initialStockController = TextEditingController();
  final _minStockController = TextEditingController();
  final _noteController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedUnitId;
  String? _imageUrl;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _initialStockController.dispose();
    _minStockController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ── Computed helpers ─────────────────────────────────────────────────────

  double get _cost => double.tryParse(_costPriceController.text) ?? 0;
  double get _sell => double.tryParse(_sellingPriceController.text) ?? 0;
  double get _stock => double.tryParse(_initialStockController.text) ?? 0;
  double get _minStock => double.tryParse(_minStockController.text) ?? 0;

  double? get _marginPercent {
    if (_sell <= 0) return null;
    return ((_sell - _cost) / _sell) * 100;
  }

  StatusType get _previewStatus {
    if (_stock == 0) return StatusType.outOfStock;
    if (_minStock > 0 && _stock <= _minStock) return StatusType.lowStock;
    return StatusType.inStock;
  }

  String get _previewStatusText {
    switch (_previewStatus) {
      case StatusType.outOfStock:
        return 'Out of Stock';
      case StatusType.lowStock:
        return 'Low Stock';
      default:
        return 'In Stock';
    }
  }

  void _genSku() {
    setState(() {
      _skuController.text =
          'PRD-${DateTime.now().millisecondsSinceEpoch % 100000}';
    });
  }

  // ── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedUnitId == null) {
      AppSnackBar.showError(context, message: 'Please, select unit');
      return;
    }
    if (_selectedCategoryId == null) {
      AppSnackBar.showError(context, message: 'Please, select category');
      return;
    }

    setState(() => _isSaving = true);

    final product = ProductModel(
      id: Uuid().v4(),
      name: _nameController.text.trim(),
      sku: _skuController.text.trim(),
      barcode: _barcodeController.text.trim(),
      categoryId: _selectedCategoryId ?? 0,
      unitId: _selectedUnitId ?? 0,
      costPrice: _cost,
      sellingPrice: _sell,
      minStock: _minStock,
      imageUrl: _imageUrl,
      note: _noteController.text.trim(),
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      currentStock: _stock,
      category: '',
      status: _previewStatus,
      statusText: _previewStatusText,
    );

    context.read<AddProductCubit>().addProduct(product);

    setState(() => _isSaving = false);


  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductCubit,AddProductState>(
  listener: (context, state) {
    if(state.product!=null&&!state.isSaving){
      AppSnackBar.showSuccess(context, message:"${state.product?.id} added successfully");
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

  },
  child: Form(
      key: _formKey,
      onChanged: () => setState(() {}), // keeps preview + checklist live
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: form sections ────────────────────────────────────────
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Basic information ──────────────────────────────────
                  BasicInformationSection(
                    onCategoryChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    nameController: _nameController,
                    skuController: _skuController,
                    barcodeController: _barcodeController,
                    onUnitChanged: (value) {
                      setState(() {
                        _selectedUnitId = value;
                      });
                    },
                    onGenerateSku: () => _genSku(),
                  ),
                  // // ── Pricing ────────────────────────────────────────────
                  PricingSection(
                    costPriceController: _costPriceController,
                    sellingPriceController: _sellingPriceController,
                    marginCard: MarginCard(
                      sell: _sell,
                      cost: _cost,
                      marginPercent: _marginPercent,
                    ),
                  ),

                  // ── Inventory ──────────────────────────────────────────
                  InventorySection(
                    initialStockController: _initialStockController,
                    minStockController: _minStockController,
                  ),

                  // ── Product image ──────────────────────────────────────
                  ProductSectionCard(
                    icon: Icons.photo_outlined,
                    title: 'Product image',
                    children: [
                      ImagePickerWidget(
                        onImagePicked: (url) => setState(() => _imageUrl = url),
                      ),
                    ],
                  ),

                  // ── Notes ─────────────────────────────────────────────
                  NotesSection(noteController: _noteController),
                  // ── Action row ─────────────────────────────────────────
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Discard'),
                      ),
                      SizedBox(width: 12.w),
                      BlocBuilder<AddProductCubit, AddProductState>(
                        builder: (context, state) {
                          return FilledButton.icon(
                            onPressed: () {
                              _isSaving ? null : _submit(context);
                            },
                            icon: _isSaving
                                ? SizedBox(
                                    width: 16.r,
                                    height: 16.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save_rounded, size: 18),
                            label: Text(_isSaving ? 'Saving…' : 'Save product'),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // ── Right: live preview sidebar ────────────────────────────────
          SizedBox(width: 10.w.clamp(6, 15)),
          SizedBox(
            width: 300,
            child: ProductSummaryPanel(
              sell: _sell,
              selectedCategoryId: _selectedCategoryId,
              nameController: _nameController,
              skuController: _skuController,
              stock: _stock,
              previewStatusText: _previewStatusText,
              previewStatus: _previewStatus,
            ),
          ),
        ],
      ),
    ),
);
  }
}
