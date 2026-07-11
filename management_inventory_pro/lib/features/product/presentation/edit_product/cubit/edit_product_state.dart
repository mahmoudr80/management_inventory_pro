part of 'edit_product_cubit.dart';

@immutable
class EditProductState {
  final bool isLoading;
  final bool isSaving;

  final List<CategoryModel> categories;
  final List<UnitModel> units;

  /// Set once the UPDATE has succeeded — carries the persisted product
  /// back to the form/screen so it can pop with the fresh data.
  final ProductModel? updatedProduct;

  final String? error;
  final String? skuError;
  final String? barcodeError;

  const EditProductState({
    this.isLoading = false,
    this.isSaving = false,
    this.categories = const [],
    this.units = const [],
    this.updatedProduct,
    this.error,
    this.skuError,
    this.barcodeError,
  });

  EditProductState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<CategoryModel>? categories,
    List<UnitModel>? units,
    ProductModel? updatedProduct,
    String? error,
    String? skuError,
    String? barcodeError,
  }) {
    return EditProductState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      categories: categories ?? this.categories,
      units: units ?? this.units,
      updatedProduct: updatedProduct ?? this.updatedProduct,
      error: error,
      skuError: skuError,
      barcodeError: barcodeError,
    );
  }
}
