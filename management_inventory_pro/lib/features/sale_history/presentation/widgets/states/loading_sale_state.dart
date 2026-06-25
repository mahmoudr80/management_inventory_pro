import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesLoadingState extends StatefulWidget {
  const SalesLoadingState({super.key});

  @override
  State<SalesLoadingState> createState() => _SalesLoadingStateState();
}

class _SalesLoadingStateState extends State<SalesLoadingState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
            // Summary cards skeleton
            Row(
              children: List.generate(
                5,
                (i) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 4 ? 12.w : 0),
                    child: _SkeletonCard(height: 96.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Filters bar skeleton
            _SkeletonCard(height: 56.h),
            SizedBox(height: 16.h),

            // Table skeleton
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: _TableSkeleton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(10.r),
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
      height: height ?? 12.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

class _TableSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header placeholder
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            color: const Color(0xFFF9FAFB),
            child: Row(
              children: [50.w, 100.w, 10.w, 10.w, 40.w, 20.w, 20.w]
                  .map((w) => Padding(
                        padding: EdgeInsets.only(right: 2.w),
                        child: _SkeletonLine(width: w, height: 10.h),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ...List.generate(
            8,
            (i) => Column(
              children: [
                Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    children: [
                      _SkeletonLine(width: 50.w),
                      SizedBox(width: 4.w),
                      _SkeletonLine(width: 100.w),
                      SizedBox(width: 4.w),
                      _SkeletonLine(width: 10.w),
                      SizedBox(width: 4.w),
                      _SkeletonLine(width: 10.w),
                      SizedBox(width: 4.w),
                      _SkeletonLine(width: 40.w),
                      SizedBox(width: 4.w),
                      _SkeletonLine(width: 20.w, height: 20.h),
                      SizedBox(width: 4.w),
                      _SkeletonLine(width: 20.w),
                    ],
                  ),
                ),
                if (i < 7)
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
