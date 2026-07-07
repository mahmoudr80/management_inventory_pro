import 'package:flutter/material.dart';

class SalesTrendBadge extends StatelessWidget {
  final double percent;
  final bool light;

  const SalesTrendBadge({
    super.key,
    required this.percent,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = percent >= 0;
    final fg = light
        ? Colors.white
        : (isUp ? const Color(0xFF15803D) : const Color(0xFFBA1A1A));
    final bg = light
        ? Colors.white.withOpacity(0.18)
        : (isUp ? const Color(0xFFDCFCE7) : const Color(0xFFFFE2E0));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 13,
            color: fg,
          ),
          const SizedBox(width: 3),
          Text(
            overflow: TextOverflow.ellipsis,
            '${isUp ? '+' : ''}${percent.toStringAsFixed(0)}%',
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
