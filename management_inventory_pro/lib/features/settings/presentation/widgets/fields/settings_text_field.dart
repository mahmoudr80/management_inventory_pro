import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_colors.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

/// Labeled single-line text input for settings forms.
///
/// Owns its own [TextEditingController] seeded once from [initialValue]
/// instead of being driven by it on every build. Settings fields round-trip
/// through the Cubit on each keystroke (`onChanged` -> `cubit.updateX` ->
/// new state -> this widget rebuilds with the *same* `initialValue`) —
/// if the controller's text were reset from `initialValue` on every
/// build, the cursor would jump to the end after every character typed.
class SettingsTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final String? hint;
  final ValueChanged<String> onChanged;
  final Widget? prefixIcon;
  final int maxLines;
  final TextInputType keyboardType;

  const SettingsTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.hint,
    this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<SettingsTextField> createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<SettingsTextField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMd.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          style: AppTextStyles.bodyMd,
          onChanged: widget.onChanged,
          decoration: AppDecorations.inputField(
            hint: widget.hint,
            prefixIcon: widget.prefixIcon,
          ),
        ),
      ],
    );
  }
}
