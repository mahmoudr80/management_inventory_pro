import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class StockEntryLoadingSkeleton extends StatefulWidget {
  final int rowCount;

  const StockEntryLoadingSkeleton({super.key, this.rowCount = 8});

  @override
  State<StockEntryLoadingSkeleton> createState() =>
      _StockEntryLoadingSkeletonState();
}

class _StockEntryLoadingSkeletonState
    extends State<StockEntryLoadingSkeleton>
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => Column(
        children: List.generate(
          widget.rowCount,
              (i) => _SkeletonRow(opacity: _animation.value, index: i),
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  final double opacity;
  final int index;

  const _SkeletonRow({required this.opacity, required this.index});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: 40,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.outlineVariant),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            _Bone(width: 120, color: AppColors.primaryFixed),
            const SizedBox(width: 24),
            _Bone(width: 180),
            const Spacer(),
            _Bone(width: 48),
            const SizedBox(width: 24),
            _Bone(width: 80),
            const SizedBox(width: 24),
            _Bone(width: 96),
            const SizedBox(width: 24),
            _Bone(width: 64),
          ],
        ),
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final Color color;

  const _Bone({
    required this.width,
    this.color = AppColors.surfaceContainerHigh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}