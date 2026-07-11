import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';
import 'package:management_inventory_pro/features/category/data/respository/category_repository.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:management_inventory_pro/features/unit/data/models/unit_model.dart';
import 'package:management_inventory_pro/features/unit/data/respository/unit_repository.dart';

part 'edit_product_state.dart';

/// Cubit for the Edit Product feature.
///
/// Loads categories/units the same way AddProductCubit does, so both
/// forms behave consistently — but is kept as its own Cubit rather than
/// reusing AddProductCubit directly, since its write path is
/// fundamentally different: this Cubit only ever issues an UPDATE
/// against an *existing* product's master-data fields, and owns
/// SKU/barcode uniqueness checks that Add Product doesn't need (a brand
/// new product can never collide with itself).
///
/// Never touches current_stock. Inventory quantity changes only through
/// Stock Entry / Stock Adjustment.
class EditProductCubit extends Cubit<EditProductState> {
  EditProductCubit(
    this._productRepository,
    this._categoryRepository,
    this._unitRepository,
  ) : super(const EditProductState());

  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;
  final UnitRepository _unitRepository;

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, error: null));

    List<CategoryModel> categories = [];
    List<UnitModel> units = [];

    final categoriesResponse = await _categoryRepository.getCategories();
    switch (categoriesResponse) {
      case Success(data: final data):
        categories = data;
      case Failure(errorModel: final err):
        emit(state.copyWith(isLoading: false, error: err.message));
        return;
    }

    final unitsResponse = await _unitRepository.getUnits();
    switch (unitsResponse) {
      case Success(data: final data):
        units = data;
      case Failure(errorModel: final err):
        emit(state.copyWith(isLoading: false, error: err.message));
        return;
    }

    emit(state.copyWith(
      isLoading: false,
      categories: categories,
      units: units,
    ));
  }

  /// Validates SKU/barcode uniqueness (ignoring [product] itself) and,
  /// if clear, persists the UPDATE for [product]'s master-data fields.
  ///
  /// [product] must already carry the *original* id/createdAt/currentStock
  /// — this Cubit doesn't compute or protect those, the caller (the form)
  /// is responsible for building [product] via the original model's
  /// copyWith so those fields are always carried over unchanged. The
  /// datasource additionally strips current_stock/created_at/id from the
  /// SQL payload as a second line of defense.
  Future<void> updateProduct(ProductModel product) async {
    emit(state.copyWith(
      isSaving: true,
      error: null,
      skuError: null,
      barcodeError: null,
    ));

    final sku = product.sku.trim();
    if (sku.isNotEmpty) {
      final taken = await _productRepository.isSkuTaken(sku, product.id);
      if (taken) {
        emit(state.copyWith(
          isSaving: false,
          skuError: 'This SKU is already used by another product',
        ));
        return;
      }
    }

    final barcode = product.barcode?.trim() ?? '';
    if (barcode.isNotEmpty) {
      final taken = await _productRepository.isBarcodeTaken(barcode, product.id);
      if (taken) {
        emit(state.copyWith(
          isSaving: false,
          barcodeError: 'This barcode is already used by another product',
        ));
        return;
      }
    }

    final response = await _productRepository.updateProduct(product);
    switch (response) {
      case Success():
        emit(state.copyWith(isSaving: false, updatedProduct: product));
      case Failure(errorModel: final error):
        emit(state.copyWith(isSaving: false, error: error.message));
    }
  }
}
