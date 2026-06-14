part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}
final class ProductLoading extends ProductState {}

final class ProductSuccess extends ProductState {
  final List<ProductModel> products;    // currently displayed (filtered)
  final List<ProductModel> allProducts; // original full list
  final String? selectedCategory;
  final String? selectedUnit;

  ProductSuccess(
      this.products, {
        List<ProductModel>? allProducts,
        this.selectedCategory,
        this.selectedUnit,
      }) : allProducts = allProducts ?? products;

  ProductSuccess copyWith({
    List<ProductModel>? products,
    List<ProductModel>? allProducts,
    String? selectedCategory,
    String? selectedUnit,
    bool clearCategory = false,
    bool clearUnit = false,
  }) {
    return ProductSuccess(
      products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedUnit: clearUnit ? null : (selectedUnit ?? this.selectedUnit),
    );
  }
}

final class ProductFailure extends ProductState {
  final String message;
  ProductFailure(this.message);
}