import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/networking/api_result.dart';
import '../../data/models/supplier_model.dart';
import '../../data/repository/supplier_repository.dart';
import 'suppliers_state.dart';

class SuppliersCubit extends Cubit<SuppliersState> {
  SuppliersCubit(this._repository) : super(const SuppliersState());
final SupplierRepository _repository;

 Future<void> loadSuppliers() async {
    emit(state.copyWith(status: SuppliersStatus.loading));
      final response = await _repository.getSuppliers();
      switch(response){
        case Success(data:final suppliers):
          emit(state.copyWith(
            status: SuppliersStatus.success,
            suppliers: suppliers,
            filteredSuppliers: suppliers,
          ));
        case Failure(errorModel:final error):
          emit(state.copyWith(
            status: SuppliersStatus.failure,
            errorMessage: error.message.toString(),
          ));
      }
  }

  void search(String query) {
    final q = query.toLowerCase().trim();
    final filtered = state.suppliers.where((s) {
      return s.companyName.toLowerCase().contains(q) ||
          s.email.toLowerCase().contains(q) ||
          s.phone.contains(q) ||
          s.address.toLowerCase().contains(q);
    }).toList();
    emit(state.copyWith(
      searchQuery: query,
      filteredSuppliers: filtered,
    ));
  }

  void clearSearch() {
    emit(state.copyWith(
      searchQuery: '',
      filteredSuppliers: state.suppliers,
    ));
  }

  void selectSupplier(SupplierModel supplier) {
    emit(state.copyWith(selectedSupplier: supplier));
  }

  void clearSelection() {
    emit(state.copyWith(clearSelectedSupplier: true));
  }

  void openAddForm() {
    emit(state.copyWith(
      isFormOpen: true,
      isEditMode: false,
      clearSelectedSupplier: true,
    ));
  }

  void openEditForm(SupplierModel supplier) {
    emit(state.copyWith(
      isFormOpen: true,
      isEditMode: true,
      selectedSupplier: supplier,
    ));
  }

  void closeForm() {
    emit(state.copyWith(isFormOpen: false, isEditMode: false));
  }

  Future<void> addSupplier(SupplierModel supplier) async {
   final response = await _repository.addSupplier(supplier);
   switch(response){
     case Success():
       final updated = [supplier, ...state.suppliers];
       _emitUpdated(updated);
       closeForm();
     case Failure(errorModel:final error):
       emit(state.copyWith(errorMessage: error.message.toString()));
   }
  }

  Future<void> updateSupplier(SupplierModel supplier) async {
    emit(state.copyWith(status: SuppliersStatus.loading));
    final response = await _repository.updateSupplier(supplier);
   switch(response){
     case Success():
       final updated = state.suppliers
           .map((s) => s.id == supplier.id ? supplier : s)
           .toList();
       _emitUpdated(updated);
       closeForm();
     case Failure(errorModel:final error):
       emit(state.copyWith(errorMessage: error.message.toString()));


   }
 }

  Future<void> deleteSupplier(String id) async {
      final response = await _repository.deleteSupplier(id);
      switch(response){
        case Success():
          final updated = state.suppliers.where((s) => s.id != id).toList();
          _emitUpdated(updated);
          if (state.selectedSupplier?.id == id) clearSelection();
        case Failure(errorModel:final error):
          emit(state.copyWith(errorMessage: error.message.toString()));
      }
  }

  void _emitUpdated(List<SupplierModel> updated) {
    final q = state.searchQuery.toLowerCase().trim();
    final filtered = q.isEmpty
        ? updated
        : updated.where((s) {
            return s.companyName.toLowerCase().contains(q) ||
                s.email.toLowerCase().contains(q) ||
                s.phone.contains(q) ||
                s.address.toLowerCase().contains(q);
          }).toList();
    emit(state.copyWith(
      status: SuppliersStatus.success,
      suppliers: updated,
      filteredSuppliers: filtered,
    ));
  }

}
