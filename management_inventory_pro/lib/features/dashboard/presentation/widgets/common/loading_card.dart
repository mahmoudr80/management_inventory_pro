import 'package:flutter/material.dart';

class LoadingCard extends StatefulWidget {
  const LoadingCard({super.key, this.height = 120, this.borderRadius = 12});

  final double height;
  final double borderRadius;

  @override
  State<LoadingCard> createState() => _LoadingCardState();
}

class _LoadingCardState extends State<LoadingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest
              .withOpacity(_animation.value),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
      ),
    );
  }
}
