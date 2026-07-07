import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class HoverableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HoverableCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isHovered) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (_isHovered) {
          setState(() => _isHovered = false);
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppAnimation.fast,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md.r),
            border: Border.all(
              color: _isHovered ? AppColors.primary : Colors.transparent,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 4),
                color: AppColors.textPrimary.withOpacity(0.08),
              ),
            ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}