import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/models/inventory_valuation_model.dart';
import '../../data/models/stock_movement_model.dart';

/// Generic three-state pill (healthy / warning / critical) built once here
/// instead of each report re-implementing its own status colouring —
/// [StockStatus] (Inventory Valuation, Low Stock) and free-form adjustment
/// statuses (Stock Adjustment History: draft/completed/...) both route
/// through this.
class ReportStatusPill extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final bool dotOnly;

  const ReportStatusPill._({required this.label, required this.background, required this.foreground, this.dotOnly = false});

  factory ReportStatusPill.stockStatus(BuildContext context, StockStatus status, {bool dotOnly = false}) {
    final colors = context.colors;
    switch (status) {
      case StockStatus.healthy:
        return ReportStatusPill._(
          label: 'Healthy',
          background: colors.statusHealthyBg,
          foreground: colors.statusHealthyFg,
          dotOnly: dotOnly,
        );
      case StockStatus.low:
        return ReportStatusPill._(
          label: 'Low Stock',
          background: colors.statusPendingBg,
          foreground: colors.statusPendingFg,
          dotOnly: dotOnly,
        );
      case StockStatus.out:
        return ReportStatusPill._(
          label: 'Out of Stock',
          background: colors.statusCancelledBg,
          foreground: colors.statusCancelledFg,
          dotOnly: dotOnly,
        );
    }
  }

  factory ReportStatusPill.generic(BuildContext context, String status) {
    final colors = context.colors;
    final normalized = status.toLowerCase();
    if (normalized == 'completed' || normalized == 'approved') {
      return ReportStatusPill._(label: status, background: colors.statusHealthyBg, foreground: colors.statusHealthyFg);
    }
    if (normalized == 'rejected' || normalized == 'cancelled') {
      return ReportStatusPill._(label: status, background: colors.statusCancelledBg, foreground: colors.statusCancelledFg);
    }
    return ReportStatusPill._(label: status, background: colors.statusPendingBg, foreground: colors.statusPendingFg);
  }

  @override
  Widget build(BuildContext context) {
    if (dotOnly) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: foreground, shape: BoxShape.circle),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: AppTextStyles.labelCaps.copyWith(color: foreground, letterSpacing: 0)),
    );
  }
}

/// Movement-type pill for the Stock Movement ledger (Purchase / Sale /
/// Adjustment / Transfer — the reference UI's "Audit Trail" screen).
class MovementTypePill extends StatelessWidget {
  final StockMovementType type;

  const MovementTypePill({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (label, bg, fg) = switch (type) {
      StockMovementType.purchase => ('Purchase', colors.statusHealthyBg, colors.statusHealthyFg),
      StockMovementType.sale => ('Sale', colors.statusCancelledBg, colors.statusCancelledFg),
      StockMovementType.adjustment => ('Adjustment', colors.statusPendingBg, colors.statusPendingFg),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(label, style: AppTextStyles.bodySm.copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}
