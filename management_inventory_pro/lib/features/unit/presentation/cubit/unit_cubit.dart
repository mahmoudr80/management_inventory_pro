import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import 'package:management_inventory_pro/features/unit/data/models/unit_model.dart';
import 'package:management_inventory_pro/features/unit/data/respository/unit_repository.dart';
import 'package:meta/meta.dart';

part 'unit_state.dart';

class UnitCubit extends Cubit<UnitState> {
  UnitCubit(this._repository) : super(UnitInitial());
  final UnitRepository _repository;

  Future<void>addUnit({required String name, String ?symbol}) async {
    final response = await _repository.addUnit(name: name,symbol: symbol);
    switch(response){
      case Success():
      getUnits();
      case Failure(errorModel:final error):
        emit(UnitFailure(error.message));
    }
  }
  Future<void> deleteUnit(int id) async {
    final response = await _repository.deleteUnit(id);
    switch (response) {
      case Success():
        emit(UnitDeleteSuccess());
        getUnits();
      case Failure(errorModel: final error):
        emit(UnitFailure(error.message));
        getUnits();
    }
  }
  Future<void> getUnits() async {
    emit(UnitLoading());
    final response =
        await _repository.getUnits();
    switch (response) {
      case Success(data: final units):
        emit(GetUnitSuccess(units));
        break;
      case Failure(errorModel: final error):
        emit(UnitFailure(error.message));
        break;
    }
  }
}
