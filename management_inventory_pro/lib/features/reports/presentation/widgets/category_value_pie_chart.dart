import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/models/inventory_valuation_model.dart';

/// Dependency-free donut chart, same trade-off/rationale as
/// SalesReportScreen's `_RevenueTrendChart` CustomPainter (fl_chart not a
/// confirmed dependency yet — swap-in point noted in the Phase 3
/// wrap-up). Renders the reference UI's "Value by Category" donut with a
/// centered total and a legend below.
class CategoryValuePieChart extends StatelessWidget {
  final List<CategoryValueSlice> slices;
  final double totalValue;

  const CategoryValuePieChart({super.key, required this.slices, required this.totalValue});

  static const _paletteLight = [0xFF0041C8, 0xFF3B6BFF, 0xFF9DB4FF, 0xFFC9D5FF];

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty) return const SizedBox.shrink();
    final total = slices.fold<double>(0, (sum, s) => sum + s.value);

    return Column(
      children: [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: _DonutPainter(
                  slices: slices,
                  total: total <= 0 ? 1 : total,
                  colors: _paletteLight.map((c) => Color(c)).toList(),
                  trackColor: context.colors.surfaceContainerHigh,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('TOTAL', style: AppTextStyles.labelCaps.copyWith(color: context.colors.textSecondary)),
                      Text(_shortMoney(totalValue), style: AppTextStyles.headlineMd.copyWith(color: context.colors.textPrimary)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            for (var i = 0; i < slices.length; i++)
              _LegendEntry(
                color: Color(_paletteLight[i % _paletteLight.length]),
                label: '${slices[i].category} (${((slices[i].value / (total <= 0 ? 1 : total)) * 100).toStringAsFixed(0)}%)',
              ),
          ],
        ),
      ],
    );
  }

  String _shortMoney(double value) {
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(0)}';
  }
}

class _LegendEntry extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendEntry({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTextStyles.bodySm.copyWith(color: context.colors.textSecondary)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<CategoryValueSlice> slices;
  final double total;
  final List<Color> colors;
  final Color trackColor;

  _DonutPainter({required this.slices, required this.total, required this.colors, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.38;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    var startAngle = -math.pi / 2;
    for (var i = 0; i < slices.length; i++) {
      final sweep = (slices[i].value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.slices != slices;
}
