import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/supplier_model.dart';

class SupplierListTile extends StatelessWidget {
  final SupplierModel supplier;
  final bool isSelected;
  final bool showPhone;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SupplierListTile({
    super.key,
    required this.supplier,
    required this.isSelected,
    this.showPhone = true,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.secondaryContainer.withAlpha(90)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant.withAlpha(153)),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Avatar
              _SupplierAvatar(name: supplier.companyName),
              const SizedBox(width: 12),

              // Name & email
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.companyName,
                      style: AppTextStyles.headlineSm.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      supplier.email,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Phone — hidden on small screens
              if (showPhone) ...[
                Expanded(
                  flex: 2,
                  child: Text(
                    supplier.phone,
                    style: AppTextStyles.dataMono.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Actions
              _TileActions(onEdit: onEdit, onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar
// ---------------------------------------------------------------------------
class _SupplierAvatar extends StatelessWidget {
  final String name;
  const _SupplierAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    // Deterministic hue from name
    final hue = (name.codeUnits.fold(0, (a, b) => a + b) % 12) * 30.0;
    final bg = HSLColor.fromAHSL(1, hue, 0.45, 0.88).toColor();
    final fg = HSLColor.fromAHSL(1, hue, 0.55, 0.28).toColor();

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyles.labelCaps.copyWith(color: fg, fontSize: 13),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Row actions
// ---------------------------------------------------------------------------
class _TileActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _TileActions({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconBtn(icon: Icons.edit_outlined, tooltip: 'Edit', onTap: onEdit),
        const SizedBox(width: 2),
        _MoreMenu(onDelete: onDelete),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: AppColors.outline),
        ),
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  final VoidCallback onDelete;
  const _MoreMenu({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.outline),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),
      color: AppColors.surfaceContainerLowest,
      elevation: 3,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
              const SizedBox(width: 8),
              Text('Delete', style: AppTextStyles.bodyMd.copyWith(color: AppColors.error)),
            ],
          ),
        ),
      ],
      onSelected: (v) {
        if (v == 'delete') onDelete();
      },
    );
  }
}
