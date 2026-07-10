import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme_extension.dart';

class CheckRow extends StatelessWidget {
  const CheckRow({super.key, required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 16,
            color: done
                ? context.colors.success
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: done
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}