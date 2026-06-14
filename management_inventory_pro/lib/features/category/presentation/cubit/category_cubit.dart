import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/features/category/data/models/category_model.dart';
import 'package:management_inventory_pro/features/category/data/respository/category_repository.dart';
import 'package:meta/meta.dart';

import '../../../../core/networking/api_result.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._repository) : super(CategoryInitial());
final CategoryRepository _repository;

  Future<void> addCategory(String name) async {
    final response = await _repository.addCategory(name);
    switch (response) {
      case Success():
        getCategories();
      case Failure(errorModel: final error):
        emit(CategoryFailure(error.message));
    }
  }
  Future<void> deleteCategory(int id) async {
    final response = await _repository.deleteCategory(id);
    switch (response) {
      case Success():
        emit(CategoryDeleteSuccess());
        getCategories();
      case Failure(errorModel: final error):
        emit(CategoryFailure(error.message));
        getCategories();
    }
  }
  Future<void> getCategories() async {
    emit(CategoryLoading());
    final response =
    await _repository.getCategories();
    switch (response) {
      case Success(data: final categories):
        emit(GetCategorySuccess(categories));
        break;
      case Failure(errorModel: final error):
        emit(CategoryFailure(error.message));
        break;
    }
  }
}
