import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/supplier_model.dart';
import 'suppliers_state.dart';

class SuppliersCubit extends Cubit<SuppliersState> {
  SuppliersCubit() : super(const SuppliersState());

  // ---------------------------------------------------------------------------
  // Load
  // ---------------------------------------------------------------------------

  Future<void> loadSuppliers() async {
    emit(state.copyWith(status: SuppliersStatus.loading));
    try {
      // TODO: Replace with repository call
      await Future.delayed(const Duration(milliseconds: 600));// todo : remove this after build data layer
      final mock = _mockSuppliers();
      emit(state.copyWith(
        status: SuppliersStatus.success,
        suppliers: mock,
        filteredSuppliers: mock,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SuppliersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Search / Filter
  // ---------------------------------------------------------------------------

  void search(String query) {
    final q = query.toLowerCase().trim();
    final filtered = state.suppliers.where((s) {
      return s.name.toLowerCase().contains(q) ||
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

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  void selectSupplier(SupplierModel supplier) {
    emit(state.copyWith(selectedSupplier: supplier));
  }

  void clearSelection() {
    emit(state.copyWith(clearSelectedSupplier: true));
  }

  // ---------------------------------------------------------------------------
  // Form open / close
  // ---------------------------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // CRUD  (UI-layer only — wire to repository when data layer is ready)
  // ---------------------------------------------------------------------------

  Future<void> addSupplier(SupplierModel supplier) async {
    try {
      // TODO: repository.add(supplier)
      final updated = [supplier, ...state.suppliers];
      _emitUpdated(updated);
      closeForm();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> updateSupplier(SupplierModel supplier) async {
    try {
      // TODO: repository.update(supplier)
      final updated = state.suppliers
          .map((s) => s.id == supplier.id ? supplier : s)
          .toList();
      _emitUpdated(updated);
      closeForm();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      // TODO: repository.delete(id)
      final updated = state.suppliers.where((s) => s.id != id).toList();
      _emitUpdated(updated);
      if (state.selectedSupplier?.id == id) clearSelection();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _emitUpdated(List<SupplierModel> updated) {
    final q = state.searchQuery.toLowerCase().trim();
    final filtered = q.isEmpty
        ? updated
        : updated.where((s) {
            return s.name.toLowerCase().contains(q) ||
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

  // ---------------------------------------------------------------------------
  // Mock data — remove when repository is connected
  // ---------------------------------------------------------------------------

  List<SupplierModel> _mockSuppliers() {
    final now = DateTime.now();
    return [
      SupplierModel(
        id: '1',
        name: 'Global Agri-Co',
        phone: '+1 (555) 902-3421',
        email: 'sarah.mitchell@globalagrico.com',
        address: '14 Farm Road, Chicago, IL 60601',
        notes: 'Primary fresh produce supplier. Delivers Mon & Thu.',
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      SupplierModel(
        id: '2',
        name: 'PackRight Solutions',
        phone: '+1 (555) 123-8877',
        email: 'david.chen@packright.com',
        address: '88 Industrial Blvd, Detroit, MI 48201',
        notes: 'Packaging materials. Net-30 payment terms.',
        createdAt: now.subtract(const Duration(days: 300)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      SupplierModel(
        id: '3',
        name: 'Northern Dairy Hub',
        phone: '+1 (555) 441-0092',
        email: 'linda.foster@northerndairy.com',
        address: '3 Creamery Lane, Green Bay, WI 54301',
        createdAt: now.subtract(const Duration(days: 250)),
        updatedAt: now.subtract(const Duration(days: 20)),
      ),
      SupplierModel(
        id: '4',
        name: 'EcoLogistics Ltd',
        phone: '+1 (555) 301-2291',
        email: 'marcus.thorne@ecologistics.com',
        address: '500 Freight Ave, Memphis, TN 38103',
        notes: 'Third-party logistics partner. Carbon-neutral fleet.',
        createdAt: now.subtract(const Duration(days: 200)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      SupplierModel(
        id: '5',
        name: 'Zenith Bottling',
        phone: '+1 (555) 609-1144',
        email: 'julia.vance@zenithbottling.com',
        address: '22 Harbor Dr, Tampa, FL 33601',
        notes: 'High outstanding balance — escalate to finance.',
        createdAt: now.subtract(const Duration(days: 180)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      SupplierModel(
        id: '6',
        name: 'SunHarvest Organics',
        phone: '+1 (555) 770-4412',
        email: 'orders@sunharvest.com',
        address: '7 Valley Rd, Fresno, CA 93650',
        createdAt: now.subtract(const Duration(days: 120)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),
    ];
  }
}
