import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/widgets/custom_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/supplier_model.dart';
import '../../cubit/suppliers_cubit.dart';

class SupplierFormDialog extends StatefulWidget {
  final SupplierModel? supplier; // null → add mode

  const SupplierFormDialog({super.key, this.supplier});

  @override
  State<SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends State<SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _notesCtrl;

  bool get _isEdit => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    final s = widget.supplier;
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _phoneCtrl = TextEditingController(text: s?.phone ?? '');
    _emailCtrl = TextEditingController(text: s?.email ?? '');
    _addressCtrl = TextEditingController(text: s?.address ?? '');
    _notesCtrl = TextEditingController(text: s?.notes ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _phoneCtrl,
      _emailCtrl,
      _addressCtrl,
      _notesCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<SuppliersCubit>();
    final now = DateTime.now();

    if (_isEdit) {
      final updated = widget.supplier!.copyWith(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        updatedAt: now,
      );
      cubit.updateSupplier(updated);
    } else {
      final newSupplier = SupplierModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        createdAt: now,
        updatedAt: now,
      );
      cubit.addSupplier(newSupplier);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _isEdit
                            ? Icons.edit_outlined
                            : Icons.add_business_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isEdit ? 'Edit Supplier' : 'Add Supplier',
                        style: AppTextStyles.headlineMd,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.read<SuppliersCubit>().closeForm(),
                      icon: const Icon(Icons.close, size: 20),
                      color: AppColors.outline,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Fields
                CustomTextField(
                  inputDecoration:
                      AppDecorations.searchField(
                        hint: 'e.g. Global Agri-Co',
                      ).copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                      ),
                  label: 'Supplier Name *',
                  controller: _nameCtrl,
                  validator: _required,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        inputDecoration:
                            AppDecorations.searchField(
                              hint: '+1 (555) 000-0000',
                            ).copyWith(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 11,
                              ),
                            ),
                        label: 'Phone *',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        inputDecoration:
                            AppDecorations.searchField(
                              hint: 'contact@supplier.com',
                            ).copyWith(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 11,
                              ),
                            ),
                        label: 'Email *',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: _email,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Address *',
                  inputDecoration:
                      AppDecorations.searchField(
                        hint: '123 Warehouse Blvd, City, State',
                      ).copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                      ),
                  controller: _addressCtrl,
                  validator: _required,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  inputDecoration:
                      AppDecorations.searchField(
                        hint: 'Optional internal notes…',
                      ).copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                      ),
                  label: 'Notes',
                  controller: _notesCtrl,
                  maxLines: 3,
                ),
                const SizedBox(height: 28),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _CancelButton(
                      onPressed: () =>
                          context.read<SuppliersCubit>().closeForm(),
                    ),
                    const SizedBox(width: 12),
                    _SubmitButton(
                      label: _isEdit ? 'Save Changes' : 'Add Supplier',
                      onPressed: _submit,
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

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;

  String? _email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email';
    return null;
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CancelButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.outlineVariant),
        foregroundColor: AppColors.onSurfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text('Cancel', style: AppTextStyles.bodyMd),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _SubmitButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMd.copyWith(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
