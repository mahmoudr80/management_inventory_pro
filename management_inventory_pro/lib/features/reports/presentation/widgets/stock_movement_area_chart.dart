import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../data/models/stock_movement_model.dart';

/// Dependency-free filled-area chart for Inbound vs Outbound over time —
/// same CustomPainter approach as SalesReportScreen's revenue trend line
/// chart, extended with a fill under the line to read as "area" per the
/// Phase 2 spec ("Stock Movement: Area Chart").
class StockMovementAreaChart extends StatelessWidget {
  final List<StockMovementTrendPoint> points;

  const StockMovementAreaChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return CustomPaint(
      size: Size.infinite,
      painter: _AreaPainter(
        points: points,
        inboundColor: context.colors.success,
        outboundColor: context.colors.error,
        gridColor: context.colors.outlineVariant,
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  final List<StockMovementTrendPoint> points;
  final Color inboundColor;
  final Color outboundColor;
  final Color gridColor;

  _AreaPainter({
    required this.points,
    required this.inboundColor,
    required this.outboundColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = points.expand((p) => [p.inbound, p.outbound]).fold<double>(0, (m, v) => v > m ? v : m);
    final safeMax = maxValue <= 0 ? 1 : maxValue;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var i = 0; i <= 3; i++) {
      final y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    void drawArea(List<double> values, Color color) {
      final linePath = Path();
      final fillPath = Path();
      for (var i = 0; i < values.length; i++) {
        final x = values.length == 1 ? 0.0 : size.width * (i / (values.length - 1));
        final y = size.height - (values[i] / safeMax) * size.height;
        if (i == 0) {
          linePath.moveTo(x, y);
          fillPath.moveTo(x, size.height);
          fillPath.lineTo(x, y);
        } else {
          linePath.lineTo(x, y);
          fillPath.lineTo(x, y);
        }
      }
      if (values.isNotEmpty) {
        fillPath.lineTo(size.width, size.height);
        fillPath.close();
      }

      canvas.drawPath(fillPath, Paint()..color = color.withOpacity(0.12));
      canvas.drawPath(linePath, Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke);
    }

    drawArea(points.map((p) => p.inbound).toList(), inboundColor);
    drawArea(points.map((p) => p.outbound).toList(), outboundColor);
  }

  @override
  bool shouldRepaint(covariant _AreaPainter oldDelegate) => oldDelegate.points != points;
}
