import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dialogs/dialog_utils.dart';
import '../../../../../core/utils/app_snackBar.dart';
import '../../../../../core/widgets/dropdown_item.dart';
import '../../../../../core/widgets/filter_dropdown.dart';
import '../../../../unit/presentation/add_unit_dialog.dart';
import '../../../../unit/presentation/cubit/unit_cubit.dart';
import '../cubit/product_cubit.dart';

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
              GetUnitSuccess(units: final list) => list
                  .map((u) => DropdownItem<int>(
                id: u.id,
                label: u.name,
              ))
                  .toList(),
              _ => <DropdownItem<int>>[],
            };

            final selectedUnit = units
                .where((u) => u.label == selUnit)
                .cast<DropdownItem<int>?>()
                .firstOrNull;

            return FilterDropdown<int>(
              icon: Icons.straighten_outlined,
              label: 'Unit',
              items: units,
              selectedItem: selectedUnit,

              onChanged: (item) {
                if (item == null) {
                  context.read<ProductCubit>().clearFilters();
                } else {
                  context.read<ProductCubit>().filterByUnit(item.label);
                  // Better: filterByUnit(item.id)
                }
              },

              onAdd: () => _openAddUnit(context),

              addLabel: 'New unit',

              onDelete: (item) {
                showDeleteConfirmation(
                  context: context,
                  title: 'Delete unit',
                  itemName: item.label,
                  onConfirm: () => unitCubit.deleteUnit(item.id),
                );
              },
            );
          },
        ),
      );
    }
  }
