import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/suppliers_empty_state.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/suppliers_error_state.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/suppliers_list_view.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/suppliers_loading_state.dart';
import '../../cubit/suppliers_cubit.dart';
import '../../cubit/suppliers_state.dart';

class SuppliersListSection extends StatelessWidget {
  const SuppliersListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliersCubit, SuppliersState>(
      builder: (context, state) {
        if (state.status == SuppliersStatus.loading) {
          return const SuppliersLoadingState();
        }

        if (state.status == SuppliersStatus.failure) {
          return SuppliersErrorState(message: state.errorMessage ?? 'Something went wrong');
        }

        if (state.filteredSuppliers.isEmpty) {
          return SuppliersEmptyState(hasQuery: state.searchQuery.isNotEmpty);
        }

        return SuppliersListView(
          suppliers: state.filteredSuppliers,
          selectedId: state.selectedSupplier?.id,
        );
      },
    );
  }
}


