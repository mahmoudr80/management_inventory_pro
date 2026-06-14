import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._repository) : super(ProductInitial());
  final ProductRepository _repository;

  Future<void> getProducts() async {
    emit(ProductLoading());
    final response = await _repository.getProducts();
    switch (response) {
      case Success(data: final data):
        emit(ProductSuccess(data));
        break;
      case Failure(errorModel: final error):
        emit(ProductFailure(error.message));
        break;
    }
  }

  Future<void> updateProducts(ProductModel? product) async {
    if (product == null || state is! ProductSuccess) return;
    final currentState = state as ProductSuccess;
    final updated = [product, ...currentState.allProducts];
    emit(currentState.copyWith(
      allProducts: updated,
      products: _applyFilters(updated, currentState.selectedCategory, currentState.selectedUnit),
    ));
  }

  void filterByCategory(String category) {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    emit(current.copyWith(
      products: _applyFilters(current.allProducts, category, null),
      selectedCategory: category,
      clearUnit: true,
    ));
  }

  void filterByUnit(String unit) {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    emit(current.copyWith(
      products: _applyFilters(current.allProducts, null, unit),
      selectedUnit: unit,
      clearCategory: true,
    ));
  }

  void clearFilters() {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    emit(current.copyWith(
      products: current.allProducts,
      clearCategory: true,
      clearUnit: true,
    ));
  }

  List<ProductModel> _applyFilters(
      List<ProductModel> source,
      String? category,
      String? unit,
      ) {
    return source.where((p) {
      final matchCat = category == null || p.category == category;
      final matchUnit = unit == null || p.unit == unit;
      return matchCat && matchUnit;
    }).toList();
  }
}

// class ProductCubit extends Cubit<ProductState> {
//   ProductCubit(this._repository) : super(ProductInitial());
//   final ProductRepository _repository;
//   Future<void> getProducts() async {
//     emit(ProductLoading());
//     final response = await _repository.getProducts();
//     switch(response){
//       case Success(data:final data):
//         emit(ProductSuccess(data,
//           categories: _extractCategories(data),
//           units: _extractUnits(data),));
//         break;
//       case Failure(errorModel:final error):
//         emit(ProductFailure(error.message));
//         break;
//     }
//   }
//   Future<void> updateProducts(ProductModel? product) async {
//     if (product == null || state is! ProductSuccess) return;
//       final currentState = state as ProductSuccess;
//     final updated = [product, ...currentState.allProducts];
//     emit(currentState.copyWith(
//       allProducts: updated,
//       products:   _applyFilters(updated, currentState.selectedCategory, currentState.selectedUnit),
//       categories: _extractCategories(updated),
//       units:      _extractUnits(updated),
//     ));
//     }
//   void filterByCategory(String category) {
//     if (state is! ProductSuccess) return;
//     final current = state as ProductSuccess;
//     emit(current.copyWith(
//       products:         _applyFilters(current.allProducts, category, null),
//       selectedCategory: category,
//       clearUnit:        true,
//     ));
//   }
//
//   void filterByUnit(String unit) {
//     if (state is! ProductSuccess) return;
//     final current = state as ProductSuccess;
//     emit(current.copyWith(
//       products:     _applyFilters(current.allProducts, null, unit),
//       selectedUnit: unit,
//       clearCategory: true,
//     ));
//   }
//   void clearFilters() {
//     if (state is! ProductSuccess) return;
//     final current = state as ProductSuccess;
//     emit(current.copyWith(
//       products:      current.allProducts,
//       clearCategory: true,
//       clearUnit:     true,
//     ));
//   }
//
//   // ── Called by ProductFilterBar after CategoryCubit succeeds ─────────────
//   // Only needed if user adds a brand-new category not yet in any product.
//
//   void addCategory(String name) {
//     if (state is! ProductSuccess) return;
//     final current = state as ProductSuccess;
//     if (current.categories.contains(name)) return;
//     emit(current.copyWith(categories: [...current.categories, name]));
//   }
//
//   // ── Called by ProductFilterBar after UnitCubit succeeds ─────────────────
//   // Only needed if user adds a brand-new unit not yet in any product.
//
//   void addUnit(String name) {
//     if (state is! ProductSuccess) return;
//     final current = state as ProductSuccess;
//     if (current.units.contains(name)) return;
//     emit(current.copyWith(units: [...current.units, name]));
//   }
//   List<String> _extractCategories(List<ProductModel> products) =>
//       products.map((p) => p.category).whereType<String>().toSet().toList();
//
//   List<String> _extractUnits(List<ProductModel> products) =>
//       products.map((p) => p.unit).whereType<String>().toSet().toList();
//
//   List<ProductModel> _applyFilters(
//       List<ProductModel> source,
//       String? category,
//       String? unit,
//       ) {
//     return source.where((p) {
//       final matchCat  = category == null || p.category == category;
//       final matchUnit = unit == null      || p.unit == unit;
//       return matchCat && matchUnit;
//     }).toList();
//   }
//   }

