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

  Future<bool>delete(String id) async {
    final response = await _repository.delete(id);
    switch(response){
      case Success():
        getProducts();
        return true;
      case Failure(errorModel:final error):
        return false;
    }
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


