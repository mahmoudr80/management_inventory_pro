import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/stock_entry_model.dart';
import '../../../data/models/stock_entry_status.dart';
import '../table/status_pill.dart';

class StockEntryDetailsHeader extends StatelessWidget {
  const StockEntryDetailsHeader({super.key, required this.entry});

  final StockEntryModel entry;

  static final _dateFmt = DateFormat('MMM d, yyyy HH:mm');
  static final _shortDate = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Receipt ID row + status ─────────────────────────────────────
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 28.r,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  entry.id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.dataMono.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              StatusPill(status: entry.status ?? StockEntryStatus.pending),
            ],
          ),

          SizedBox(height: 12.h),
          const Divider(height: 1, color: AppColors.outlineVariant),
          SizedBox(height: 12.h),

          // ── Info rows ───────────────────────────────────────────────────
          _InfoRow(
            label: 'Supplier',
            value: entry.supplier.name ?? '—',
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            label: 'Receipt Date',
            value: _shortDate.format(entry.receiptDate),
          ),
          if (entry.createdAt != null) ...[
            SizedBox(height: 8.h),
            _InfoRow(
              label: 'Created At',
              value: _dateFmt.format(entry.createdAt!),
            ),
          ],
          if (entry.updatedAt != null) ...[
            SizedBox(height: 8.h),
            _InfoRow(
              label: 'Last Updated',
              value: _dateFmt.format(entry.updatedAt!),
            ),
          ],
          if (entry.notes != null && entry.notes!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _InfoRow(label: 'Notes', value: entry.notes!),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySm.copyWith(color: AppColors.outline,fontSize: 4.sp),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySm.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              fontSize: 4.sp
            ),
          ),
        ),
      ],
    );
  }
}
