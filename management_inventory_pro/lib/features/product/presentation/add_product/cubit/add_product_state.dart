part of 'add_product_cubit.dart';

@immutable
class AddProductState {
  final bool isLoading;
  final bool isSaving;

  final List<CategoryModel> categories;
  final List<UnitModel> units;

  final ProductModel? product;

  final String? error;

  const AddProductState({
    this.isLoading = false,
    this.isSaving = false,
    this.categories = const [],
    this.units = const [],
    this.product,
    this.error,
  });

  AddProductState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<CategoryModel>? categories,
    List<UnitModel>? units,
    ProductModel? product,
    String? error,
  }) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      categories: categories ?? this.categories,
      units: units ?? this.units,
      product: product ?? this.product,
      error: error,
    );
  }
}

// @immutable
// sealed class AddProductState {}
//
// final class AddProductInitial extends AddProductState {}
// final class AddProductLoading extends AddProductState {}
// final class AddProductSuccess extends AddProductState {
//   final ProductModel products;
//
//   AddProductSuccess(this.products);
// }
// final class AddProductFailure extends AddProductState {
//   final String message;
//
//   AddProductFailure(this.message);
// }
//
// final class GetCategoriesSuccess extends AddProductState {
//   final List<CategoryModel> categories;
//
//   GetCategoriesSuccess(this.categories);
// }
// final class GetUnitsSuccess extends AddProductState {
//   final List<UnitModel> units;
//
//   GetUnitsSuccess(this.units);
// }