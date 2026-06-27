import 'dart:math' as math;

import 'package:flutter/material.dart';

enum ChartType { bar, line }

class ChartPlaceholder extends StatelessWidget {
  const ChartPlaceholder({
    super.key,
    required this.data,
    this.type = ChartType.bar,
    this.height = 160,
    this.labels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    this.accentColor,
  });

  final List<double> data;
  final ChartType type;
  final double height;
  final List<String> labels;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _ChartPainter(
          data: data,
          type: type,
          color: color,
          labelStyle: theme.textTheme.labelSmall!.copyWith(
            color: theme.colorScheme.outline,
            fontSize: 10,
          ),
          labels: labels,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.data,
    required this.type,
    required this.color,
    required this.labelStyle,
    required this.labels,
  });

  final List<double> data;
  final ChartType type;
  final Color color;
  final TextStyle labelStyle;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double labelHeight = 18;
    const double topPad = 8;
    final chartH = size.height - labelHeight - topPad;
    final maxVal = data.reduce(math.max);
    final minVal = 0.0;
    final range = maxVal - minVal;

    double normalise(double v) =>
        range == 0 ? 0.5 : (v - minVal) / range;

    final n = data.length;
    final slotW = size.width / n;

    if (type == ChartType.bar) {
      _drawBars(canvas, size, chartH, topPad, slotW, normalise);
    } else {
      _drawLine(canvas, size, chartH, topPad, slotW, normalise);
    }

    _drawLabels(canvas, size, slotW, chartH, topPad, labelHeight);
  }

  void _drawBars(Canvas canvas, Size size, double chartH, double topPad,
      double slotW, double Function(double) normalise) {
    final barW = slotW * 0.55;
    final paint = Paint()..color = color.withOpacity(0.25);
    final activeP = Paint()..color = color;

    for (int i = 0; i < data.length; i++) {
      final norm = normalise(data[i]);
      final barH = norm * chartH;
      final x = slotW * i + (slotW - barW) / 2;
      final y = topPad + chartH - barH;
      final rect = Rect.fromLTWH(x, y, barW, barH);
      final rr = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      final isLast = i == data.length - 1;
      canvas.drawRRect(rr, isLast ? activeP : paint);
    }
  }

  void _drawLine(Canvas canvas, Size size, double chartH, double topPad,
      double slotW, double Function(double) normalise) {
    final points = List.generate(data.length, (i) {
      final norm = normalise(data[i]);
      final x = slotW * i + slotW / 2;
      final y = topPad + chartH - norm * chartH;
      return Offset(x, y);
    });

    // Fill
    final fillPath = Path()..moveTo(points.first.dx, topPad + chartH);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo(points.last.dx, topPad + chartH)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
        ).createShader(
          Rect.fromLTWH(0, topPad, size.width, chartH),
        ),
    );

    // Line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Dots
    final dotP = Paint()..color = color;
    for (final p in points) {
      canvas.drawCircle(p, 3.5, dotP);
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white..strokeWidth = 1.5..style = PaintingStyle.stroke);
    }
  }

  void _drawLabels(Canvas canvas, Size size, double slotW, double chartH,
      double topPad, double labelH) {
    for (int i = 0; i < math.min(labels.length, data.length); i++) {
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = slotW * i + (slotW - tp.width) / 2;
      final y = topPad + chartH + 4;
      tp.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.data != data || old.type != type;
}
