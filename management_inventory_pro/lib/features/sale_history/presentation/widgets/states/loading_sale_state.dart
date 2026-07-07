import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimens.dart';

class _SalesLoadingStateState extends State<SalesLoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _skeletonScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _skeletonScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Opacity(
        opacity: _animation.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Scrollbar(
              controller: _skeletonScrollController,
              child: SingleChildScrollView(
                controller: _skeletonScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    5,
                        (i) => Padding(
                      padding: EdgeInsets.only(right: AppSpacing.sm),
                      child: const _SkeletonCard(width: 250, height: 50),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SkeletonCard(height: 56),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _TableSkeleton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesLoadingState extends StatefulWidget {
  const SalesLoadingState({super.key});

  @override
  State<SalesLoadingState> createState() => _SalesLoadingStateState();
}


class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.height, this.width});
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width, this.height});
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? AppSpacing.md,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}

class _TableSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header placeholder
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            color: AppColors.surfaceContainerLow,
            child: Row(
              children: [50.0, 100.0, 10.0, 10.0, 40.0, 20.0, 20.0]
                  .map((w) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: _SkeletonLine(width: w, height: 10),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ...List.generate(
            8,
            (i) => Column(
              children: [
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: const Row(
                    children: [
                      _SkeletonLine(width: 50),
                      SizedBox(width: AppSpacing.sm),
                      _SkeletonLine(width: 100),
                      SizedBox(width: AppSpacing.sm),
                      _SkeletonLine(width: 10),
                      SizedBox(width: AppSpacing.sm),
                      _SkeletonLine(width: 10),
                      SizedBox(width: AppSpacing.sm),
                      _SkeletonLine(width: 40),
                      SizedBox(width: AppSpacing.sm),
                      _SkeletonLine(width: 20, height: 20),
                      SizedBox(width: AppSpacing.sm),
                      _SkeletonLine(width: 20),
                    ],
                  ),
                ),
                if (i < 7)
                  const Divider(height: 1, color: AppColors.surfaceContainerLow),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
