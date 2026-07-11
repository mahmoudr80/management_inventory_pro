import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/unit/data/models/unit_model.dart';
import 'package:management_inventory_pro/features/unit/presentation/cubit/unit_cubit.dart';

import 'settings_dropdown.dart';

/// Default Unit picker for the Inventory settings section.
///
/// Unlike every other [SettingsDropdown] consumer, this one has no fixed
/// option list — units are business data (see the Units feature), so
/// options come live from [UnitCubit] instead of a static const list.
///
/// Two things this widget owns, because they're rendering concerns
/// specific to *this* field, not something [SettingsCubit] needs to know
/// about:
///  - Triggers [UnitCubit.getUnits] once, the same way any other
///    consumer of this cubit is expected to.
///  - Self-heals a stale [selectedUnitId] (the saved id no longer
///    exists — the unit was deleted after being picked as default) by
///    calling [onChanged] with `null` after the current frame. From
///    [SettingsCubit]'s point of view this looks exactly like the user
///    clearing the field — no special-cased "reset" path needed
///    anywhere else in the app.
class DefaultUnitDropdown extends StatefulWidget {
  final UnitCubit? unitCubit;
  final int? selectedUnitId;
  final ValueChanged<int?> onChanged;

  const DefaultUnitDropdown({
    super.key,
    required this.unitCubit,
    required this.selectedUnitId,
    required this.onChanged,
  });

  @override
  State<DefaultUnitDropdown> createState() => _DefaultUnitDropdownState();
}

class _DefaultUnitDropdownState extends State<DefaultUnitDropdown> {
  bool _healedThisSelection = false;

  @override
  void initState() {
    super.initState();
    final cubit = widget.unitCubit;
    if (cubit == null) return;
    final state = cubit.state;
    if (state is! GetUnitSuccess && state is! UnitLoading) {
      cubit.getUnits();
    }
  }

  @override
  void didUpdateWidget(covariant DefaultUnitDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUnitId != widget.selectedUnitId) {
      _healedThisSelection = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = widget.unitCubit;
    if (cubit == null) {
      // Units feature isn't available on this platform (e.g. no local
      // SQLite database — see service_locator.dart's Platform.isWindows
      // gate). Render a disabled field instead of crashing or silently
      // hiding a setting the user might expect to see.
      return SettingsDropdown<int>(
        label: 'Default Unit',
        value: null,
        options: const [],
        labelBuilder: (id) => '$id',
        onChanged: (_) {},
        emptyMessage: 'Units aren\'t available on this platform.',
      );
    }

    return BlocBuilder<UnitCubit, UnitState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is UnitLoading || state is UnitInitial) {
          return SettingsDropdown<int>(
            label: 'Default Unit',
            value: null,
            options: const [],
            labelBuilder: (id) => '$id',
            onChanged: (_) {},
            placeholder: 'Loading units…',
          );
        }

        final units = state is GetUnitSuccess ? state.units : <UnitModel>[];

        if (units.isEmpty) {
          return SettingsDropdown<int>(
            label: 'Default Unit',
            value: null,
            options: const [],
            labelBuilder: (id) => '$id',
            onChanged: (_) {},
            emptyMessage:
            'No units available — create your first unit from Settings > Units.',
          );
        }

        final ids = units.map((u) => u.id).toList();
        final stale = widget.selectedUnitId != null && !ids.contains(widget.selectedUnitId);

        if (stale && !_healedThisSelection) {
          _healedThisSelection = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onChanged(null);
          });
        }

        return SettingsDropdown<int>(
          label: 'Default Unit',
          value: stale ? null : widget.selectedUnitId,
          options: ids,
          labelBuilder: (id) => units.firstWhere((u) => u.id == id).name,
          onChanged: widget.onChanged,
          placeholder: 'Select a default unit',
        );
      },
    );
  }
}