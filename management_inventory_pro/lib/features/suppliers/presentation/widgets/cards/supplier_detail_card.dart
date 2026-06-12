import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/supplier_model.dart';

class SupplierDetailCard extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onClose;

  const SupplierDetailCard({
    super.key,
    required this.supplier,
    required this.onEdit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(color: AppColors.surfaceContainerLowest),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailHeader(supplier: supplier, onEdit: onEdit, onClose: onClose),
          const Divider(height: 1, color: AppColors.outlineVariant),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: supplier.phone,
                    mono: true,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: supplier.email,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: supplier.address,
                  ),
                  if (supplier.notes != null && supplier.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _NotesSection(notes: supplier.notes!),
                  ],
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: AppColors.outlineVariant),
                  const SizedBox(height: 16),
                  _MetaRow(
                    label: 'Created',
                    value: _formatDate(supplier.createdAt),
                  ),
                  const SizedBox(height: 8),
                  _MetaRow(
                    label: 'Last updated',
                    value: _formatDate(supplier.updatedAt),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _DetailHeader extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onClose;

  const _DetailHeader({
    required this.supplier,
    required this.onEdit,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final initials = supplier.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
      child: Row(
        children: [
          // Large avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(supplier.name, style: AppTextStyles.headlineSm),
                const SizedBox(height: 2),
                Text(
                  'ID: ${supplier.id}',
                  style: AppTextStyles.labelCaps,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            tooltip: 'Edit supplier',
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 18),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.outline,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool mono;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelCaps),
              const SizedBox(height: 2),
              Text(
                value,
                style: mono
                    ? AppTextStyles.dataMono.copyWith(color: AppColors.onSurface)
                    : AppTextStyles.bodyMd,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  final String notes;
  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notes_outlined, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              Text('Notes', style: AppTextStyles.labelCaps),
            ],
          ),
          const SizedBox(height: 6),
          Text(notes, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label:', style: AppTextStyles.labelCaps),
        const SizedBox(width: 6),
        Text(value, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }
}
