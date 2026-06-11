import 'package:equatable/equatable.dart';

import '../../data/models/supplier_model.dart';

enum SuppliersStatus { initial, loading, success, failure }

class SuppliersState extends Equatable {
  final SuppliersStatus status;
  final List<SupplierModel> suppliers;
  final List<SupplierModel> filteredSuppliers;
  final String searchQuery;
  final String? errorMessage;
  final SupplierModel? selectedSupplier;
  final bool isFormOpen;
  final bool isEditMode;

  const SuppliersState({
    this.status = SuppliersStatus.initial,
    this.suppliers = const [],
    this.filteredSuppliers = const [],
    this.searchQuery = '',
    this.errorMessage,
    this.selectedSupplier,
    this.isFormOpen = false,
    this.isEditMode = false,
  });

  SuppliersState copyWith({
    SuppliersStatus? status,
    List<SupplierModel>? suppliers,
    List<SupplierModel>? filteredSuppliers,
    String? searchQuery,
    String? errorMessage,
    SupplierModel? selectedSupplier,
    bool clearSelectedSupplier = false,
    bool? isFormOpen,
    bool? isEditMode,
  }) {
    return SuppliersState(
      status: status ?? this.status,
      suppliers: suppliers ?? this.suppliers,
      filteredSuppliers: filteredSuppliers ?? this.filteredSuppliers,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
      selectedSupplier:
          clearSelectedSupplier ? null : (selectedSupplier ?? this.selectedSupplier),
      isFormOpen: isFormOpen ?? this.isFormOpen,
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        suppliers,
        filteredSuppliers,
        searchQuery,
        errorMessage,
        selectedSupplier,
        isFormOpen,
        isEditMode,
      ];
}
