import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/features/unit/presentation/cubit/unit_cubit.dart';

import '../../../../../core/utils/app_snackBar.dart';

/// Uses [UnitCubit] for persistence, then pops the new unit name so
/// the caller ([ProductFilterBar]) can forward it to [ProductCubit].
class AddUnitDialog extends StatefulWidget {
  const AddUnitDialog({super.key});

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _symbolCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _symbolCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => _saving = true);

    final name = _nameCtrl.text.trim();

    await context.read<UnitCubit>().addUnit(name: name,symbol: _symbolCtrl.text);
    if (mounted) {
      await context.read<UnitCubit>().getUnits();
    }
    setState(() => _saving = false);
    if (mounted) {
      final cubitState = context.read<UnitCubit>().state;
      if (cubitState is UnitFailure) {
        AppSnackBar.showError(context, message: cubitState.message);
      } else {
        AppSnackBar.showSuccess(context, message: 'Unit "$name" added');
        Navigator.of(
          context,
        ).pop(name); // ← returns new name to ProductFilterBar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.w.clamp(280, 460)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.straighten_outlined,
                        size: 20.r,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Unit',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Add a measurement unit for your products',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                const Divider(height: 1),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _nameCtrl,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Unit name *',
                    hintText: 'e.g. Kilogram, Litre, Piece…',
                    prefixIcon: const Icon(Icons.straighten_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _symbolCtrl,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Symbol (optional)',
                    hintText: 'e.g. kg, L, pcs',
                    prefixIcon: const Icon(Icons.tag_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: 10.w),
                    FilledButton.icon(
                      onPressed: _saving ? null : _submit,
                      icon: _saving
                          ? SizedBox(
                              width: 14.r,
                              height: 14.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.add_rounded, size: 16.r),
                      label: Text(_saving ? 'Saving…' : 'Add Unit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
