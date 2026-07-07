import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_status.dart';
import 'package:management_inventory_pro/features/stock_receipts/presentation/widgets/table/status_pill.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_model.dart';

class EntryRow extends StatefulWidget {
  final StockEntryModel entry;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EntryRow({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.isSelected = false,
  });

  @override
  State<EntryRow> createState() => _EntryRowState();
}

class _EntryRowState extends State<EntryRow> {
  bool _hovering = false;

  static final _currencyFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  static final _dateFmt = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;

    Color bg;
    if (widget.isSelected) {
      bg = AppColors.primary.withOpacity(0.08);
    } else if (_hovering) {
      bg = AppColors.surfaceContainerLow;
    } else {
      bg = AppColors.surfaceContainerLowest;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 40,
          color: bg,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Receipt ID
              Expanded(
                flex: 3,
                child: Tooltip(
                  message: e.id,
                  child: Text(
                    e.id,
                    style: AppTextStyles.dataMono.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Supplier
              Expanded(
                flex: 4,
                child: Tooltip(
                  message: e.supplier.name ?? '—',
                  child: Text(
                    e.supplier.name ?? '—',
                    style: AppTextStyles.bodyMd,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Items
              Expanded(
                flex: 2,
                child: Text(
                  e.totalItems.toString(),
                  textAlign: TextAlign.left,
                  style: AppTextStyles.dataMono,
                ),
              ),

              // Total Value
              Expanded(
                flex: 3,
                child: Text(
                  _currencyFmt.format(e.totalCost),
                  textAlign: TextAlign.left,
                  style: AppTextStyles.dataMono,
                ),
              ),

              // Date
              Expanded(
                flex: 3,
                child: Tooltip(
                  message: _dateFmt.format(e.receiptDate),
                  child: Text(
                    _dateFmt.format(e.receiptDate),
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Status
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: StatusPill(
                    status: e.status ?? StockEntryStatus.verified,
                  ),
                ),
              ),

              // Actions
              const SizedBox(
                width: 72,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Remove individual handlers if they are simple callbacks
                  ],
                ),
              ),
              SizedBox(
                width: 72,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _RowAction(
                      icon: Icons.edit_outlined,
                      tooltip: 'Edit',
                      onTap: widget.onEdit,
                    ),
                    _RowAction(
                      icon: Icons.delete_outline,
                      tooltip: 'Delete',
                      color: AppColors.error,
                      onTap: widget.onDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color color;

  const _RowAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color = AppColors.outline,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
