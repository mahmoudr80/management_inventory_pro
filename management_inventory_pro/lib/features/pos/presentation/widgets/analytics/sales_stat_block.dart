import 'package:flutter/material.dart';

class SalesStatBlock extends StatelessWidget {
  const SalesStatBlock({super.key, required this.totalUnitsSoldToday, required this.totalSalesToday});
final int totalUnitsSoldToday;
final double totalSalesToday;
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: _StatBlock(
            label: 'Units Sold Today',
            value: '$totalUnitsSoldToday',
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _StatBlock(
            label: 'Sales Today',
            value: '\$${totalSalesToday.toStringAsFixed(2)}',
          ),
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String value;

  const _StatBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(message:  value,
            child:Text(
              overflow: TextOverflow.ellipsis,
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Tooltip(message:  label,
            child: Text(
              overflow: TextOverflow.ellipsis,
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
