import 'package:flutter/material.dart';

import '../../../../../core/theme/app_dimens.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/adjustment_reason.dart';

/// Renders an [AdjustmentReason] as a colored icon + label, matching the
/// reference table and detail panel treatment.
class ReasonTag extends StatelessWidget {
  const ReasonTag({super.key, required this.reason});

  final AdjustmentReason reason;

  @override
  Widget build(BuildContext context) {
    // Was a `Wrap` — Wrap never gives its children a bounded width, so the
    // `overflow: ellipsis` on the label text never actually had anything to
    // truncate against and long reason labels could overflow the table
    // cell. `Row` + `Flexible` gives the text a real width constraint.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(reason.icon, size: AppIconSize.md, color: reason.color),
        const SizedBox(width: AppSpacing.xxs),
        Flexible(
          child: Tooltip(
            message: reason.label,
            child: Text(
              reason.label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm,
            ),
          ),
        ),
      ],
    );
  }
}