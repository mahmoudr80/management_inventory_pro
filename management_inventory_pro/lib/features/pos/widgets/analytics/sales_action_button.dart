import 'package:flutter/material.dart';

class SalesActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  const SalesActionButton({super.key,
    required this.label,
    required this.icon,
    required this.filled,
    this.onTap,
  });

  @override
  State<SalesActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<SalesActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: widget.filled
                ? Colors.white.withOpacity(_hovered ? 0.95 : 0.85)
                : Colors.white.withOpacity(_hovered ? 0.14 : 0.0),
            borderRadius: BorderRadius.circular(11),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: widget.filled ? const Color(0xFF0041C8) : Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.filled ? const Color(0xFF0041C8) : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}