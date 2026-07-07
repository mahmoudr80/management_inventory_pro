import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/product/data/respository/product_repository.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import '../widgets/product_view_type.dart';
part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._repository) : super(ProductInitial());
  final ProductRepository _repository;

  Future<void> getProducts() async {
    // Preserve the user's current List/Grid choice across a refresh
    // (e.g. triggered by delete()) instead of resetting to list every time.
    final previousViewType =
        state is ProductSuccess ? (state as ProductSuccess).viewType : ProductViewType.list;

    emit(ProductLoading());
    final response = await _repository.getProducts();
    switch (response) {
      case Success(data: final data):
        emit(ProductSuccess(data, viewType: previousViewType));
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
      products: _applyFilters(
        updated,
        currentState.selectedCategory,
        currentState.selectedUnit,
        currentState.searchQuery,
      ),
    ));
  }

  void filterByCategory(String category) {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    emit(current.copyWith(
      products: _applyFilters(current.allProducts, category, null, current.searchQuery),
      selectedCategory: category,
      clearUnit: true,
    ));
  }

  void filterByUnit(String unit) {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    emit(current.copyWith(
      products: _applyFilters(current.allProducts, null, unit, current.searchQuery),
      selectedUnit: unit,
      clearCategory: true,
    ));
  }

  /// Filters the product list by name, SKU, or barcode. Combines with
  /// whatever category/unit filter is already active, and clears itself
  /// automatically when the query is empty.
  void searchProducts(String query) {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    final trimmed = query.trim();

    emit(current.copyWith(
      products: _applyFilters(
        current.allProducts,
        current.selectedCategory,
        current.selectedUnit,
        trimmed,
      ),
      searchQuery: trimmed,
      clearSearch: trimmed.isEmpty,
    ));
  }

  void clearFilters() {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    emit(current.copyWith(
      products: current.allProducts,
      clearCategory: true,
      clearUnit: true,
      clearSearch: true,
    ));
  }

  /// Switches between List and Grid presentation. UI-only state — does not
  /// touch products, filters, or trigger a re-fetch.
  void changeViewType(ProductViewType viewType) {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    if (current.viewType == viewType) return;
    emit(current.copyWith(viewType: viewType));
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
      String? query,
      ) {
    final normalizedQuery = (query == null || query.trim().isEmpty)
        ? null
        : query.trim().toLowerCase();

    return source.where((p) {
      final matchCat = category == null || p.category == category;
      final matchUnit = unit == null || p.unit == unit;
      final matchQuery = normalizedQuery == null ||
          p.name.toLowerCase().contains(normalizedQuery) ||
          p.sku.toLowerCase().contains(normalizedQuery) ||
          (p.barcode?.toLowerCase().contains(normalizedQuery) ?? false);
      return matchCat && matchUnit && matchQuery;
    }).toList();
  }
}
