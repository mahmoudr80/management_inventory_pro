import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dialogs/dialog_utils.dart';
import '../../../../../core/utils/app_snackBar.dart';
import '../../../../unit/presentation/add_unit_dialog.dart';
import '../../../../unit/presentation/cubit/unit_cubit.dart';
import '../cubit/product_cubit.dart';
import 'custom_drop_down.dart';

class UnitFilterDropdown extends StatelessWidget {
  const UnitFilterDropdown({super.key, required this.unitCubit, this.selUnit});
final UnitCubit unitCubit;
final String?selUnit;

  Future<void> _openAddUnit(BuildContext context) async {
    await showDialog<String>(
      context: context,
      builder: (_) =>
          BlocProvider.value(
            value: unitCubit,
            child: const AddUnitDialog(),
          ),
    );
  }

    @override
    Widget build(BuildContext context) {
      return BlocListener<UnitCubit, UnitState>(
        bloc: unitCubit,
        listener: (context, state) {
          if (state is UnitFailure) {
            AppSnackBar.showError(
                context, message: state.message, duration: 2000);
          } else if (state is UnitDeleteSuccess) {
            AppSnackBar.showSuccess(
                context, message: 'Unit deleted successfully');
          }
        },
        child: BlocBuilder<UnitCubit, UnitState>(
          bloc: unitCubit,
          builder: (context, unitState) {
            final units = switch (unitState) {
              GetUnitSuccess(units: final list) =>
                  list
                      .map((u) => DropdownItem(id: u.id, name: u.name))
                      .toList(),
              _ => <DropdownItem>[],
            };
            return CustomDropDown(
              icon: Icons.straighten_outlined,
              label: 'Unit',
              selectedValue: selUnit,
              items: units,
              onSelect: (val) =>
              val == null
                  ? context.read<ProductCubit>().clearFilters()
                  : context.read<ProductCubit>().filterByUnit(val),
              onAddNew: () => _openAddUnit(context),
              addLabel: 'New unit',
              onDelete: (id) {
                final item = units.firstWhere((u) => u.id == id);
                showDeleteConfirmation(
                  context: context,
                  title: 'Delete unit',
                  itemName: item.name,
                  onConfirm: () => unitCubit.deleteUnit(id),
                );
              },
            );
          },
        ),
      );
    }
  }
