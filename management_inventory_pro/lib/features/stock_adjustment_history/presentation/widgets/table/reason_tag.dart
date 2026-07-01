import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_reason.dart';

/// Renders an [AdjustmentReason] as a colored icon + label, matching the
/// reference table and detail panel treatment.
class ReasonTag extends StatelessWidget {
  const ReasonTag({super.key, required this.reason});

  final AdjustmentReason reason;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Icon(reason.icon, size: 20.r, color: reason.color),
        SizedBox(width: 1.w),
        Text(          overflow: TextOverflow.ellipsis,
            reason.label, style: AppTextStyles.bodySm),
      ],
    );
  }
}
