import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/features/suppliers/data/repository/supplier_repository.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../cubit/suppliers_cubit.dart';
import '../cubit/suppliers_state.dart';
import '../widgets/dialogs/supplier_form_dialog.dart';
import '../widgets/suppliers_responsive_layout.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SuppliersCubit(getIt<SupplierRepository>())..loadSuppliers(),
      child: const _SuppliersView(),
    );
  }
}

class _SuppliersView extends StatelessWidget {
  const _SuppliersView();

  @override
  Widget build(BuildContext context) {
    return  BlocListener<SuppliersCubit, SuppliersState>(
          listenWhen: (prev, curr) => prev.isFormOpen != curr.isFormOpen,
          listener: (context, state) {
            if (state.isFormOpen) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => BlocProvider.value(
                  value: context.read<SuppliersCubit>(),
                  child: SupplierFormDialog(
                    supplier: state.isEditMode ? state.selectedSupplier : null,
                  ),
                ),
              ).then((_) {
                if (context.mounted) {
                  context.read<SuppliersCubit>().closeForm();
                }
              });
            }
          },
          child:SuppliersResponsiveLayout()
      );
  }
}