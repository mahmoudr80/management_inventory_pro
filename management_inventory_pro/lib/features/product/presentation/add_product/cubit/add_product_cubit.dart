import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/features/product/data/models/product_model.dart';
import 'package:meta/meta.dart';

import '../../../../../core/networking/api_result.dart';
import '../../../data/respository/product_repository.dart';
part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this._repository) : super(AddProductInitial());
  final ProductRepository _repository;

  Future<void>addProduct(ProductModel product) async {
    final response =await _repository.addProduct(product);
    switch(response){
      case Success():
        emit(AddProductSuccess(product));
      case Failure(errorModel:final error):
        emit(AddProductFailure(error.message));
    }
  }
}
