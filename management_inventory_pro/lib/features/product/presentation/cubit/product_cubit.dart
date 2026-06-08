import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/product/data/datasource/product_datasource.dart';
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
    switch(response){
      case Success(data:final data):
        emit(ProductSuccess(data));
        break;
      case Failure(errorModel:final error):
        emit(ProductFailure(error.message));
        break;
    }
  }
}
