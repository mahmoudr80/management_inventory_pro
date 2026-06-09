// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../theme/app_colors.dart';
// import '../theme/app_text_styles.dart';
//
// class AppCard extends StatefulWidget {
//   final Widget child;
//   final String? title;
//   final Widget? titleSuffix;
//   final EdgeInsetsGeometry? padding;
//   final Color? backgroundColor;
//   final Border? border;
//
//   const AppCard({
//     super.key,
//     required this.child,
//     this.title,
//     this.titleSuffix,
//     this.padding,
//     this.backgroundColor,
//     this.border,
//   });
//
//   @override
//   State<AppCard> createState() => _AppCardState();
// }
//
// class _AppCardState extends State<AppCard> {
//    bool isHovered =false;
//   @override
//   Widget build(BuildContext context) {
//     return  MouseRegion(
//         onEnter: (_) {
//           setState(() {
//             isHovered = true;
//           });
//         },
//         onExit: (_) {
//           setState(() {
//             isHovered = false;
//           });
//         },child:  AnimatedContainer(
//         duration: const Duration(milliseconds: 150),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.r),
//           color: Colors.white,
//           border: Border.all(
//
//             color: isHovered
//                 ? Colors.blue
//                 :  AppColors.surface,
//           ),
//         ),
//         child: Container(
//       decoration: BoxDecoration(
//         color: widget.backgroundColor ??  AppColors.surface,
//         borderRadius: BorderRadius.circular(8.r), // 8px corner radius (lg in design spec)
//         border: widget.border ?? Border.all(color: AppColors.border, width: 1.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (widget.title != null || widget.titleSuffix != null) ...[
//             Padding(
//               padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (widget.title != null)
//                     Text(
//                       widget.title!,
//                       style: AppTextStyles.headlineSm.copyWith(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                     )
//                   else
//                     const SizedBox.shrink(),
//                   ?widget.titleSuffix,
//                 ],
//               ),
//             ),
//             const Divider(color: AppColors.border, height: 1.0),
//           ],
//           Padding(
//             padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//             child: widget.child,
//           ),
//         ],
//       ),
//         )) );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? titleSuffix;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.title,
    this.titleSuffix,
    this.padding,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: border ??
            Border.all(
              color: AppColors.border,
              width: 1,
            ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || titleSuffix != null) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                12.h,
                16.w,
                8.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: AppTextStyles.headlineSm.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  titleSuffix ?? const SizedBox.shrink(),
                ],
              ),
            ),
            const Divider(
              color: AppColors.border,
              height: 1,
            ),
          ],
          Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
            child: child,
          ),
        ],
      ),
    );
  }
}