import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';
import 'package:management_inventory_pro/features/category/data/respository/category_repository.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:management_inventory_pro/features/unit/data/models/unit_model.dart';
import 'package:management_inventory_pro/features/unit/data/respository/unit_repository.dart';
import 'package:meta/meta.dart';

import '../../../../../core/networking/api_result.dart';
import '../../../data/respository/product_repository.dart';
part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this._productRepository,this._categoryRepository,this._unitRepository) :
      super(const AddProductState());
  final ProductRepository _productRepository;
  final UnitRepository _unitRepository;
  final CategoryRepository _categoryRepository;


  Future<void> addProduct(ProductModel product) async {
    emit(
      state.copyWith(
        isSaving: true,
        error: null,
      ),
    );

    final response = await _productRepository.addProduct(product);

    switch (response) {
      case Success():
        emit(
          state.copyWith(
            isSaving: false,
            product: product,
          ),
        );

      case Failure(errorModel: final error):
        emit(
          state.copyWith(
            isSaving: false,
            error: error.message,
          ),
        );
    }
  }
  Future<void> loadInitialData() async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    List<CategoryModel> categories = [];
    List<UnitModel> units = [];

    final categoriesResponse =
    await _categoryRepository.getCategories();

    switch (categoriesResponse) {
      case Success(data: final data):
        categories = data;

      case Failure(errorModel: final err):
        emit(
          state.copyWith(
            isLoading: false,
            error: err.message,
          ),
        );
        return;
    }

    final unitsResponse =
    await _unitRepository.getUnits();

    switch (unitsResponse) {
      case Success(data: final data):
        units = data;

      case Failure(errorModel: final err):
        emit(
          state.copyWith(
            isLoading: false,
            error: err.message,
          ),
        );
        return;
    }

    emit(
      state.copyWith(
        isLoading: false,
        categories: categories,
        units: units,
      ),
    );
  }

}
