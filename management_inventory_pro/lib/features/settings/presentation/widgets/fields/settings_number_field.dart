import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import '../../theme/settings_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_decoration.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import 'package:management_inventory_pro/core/theme/app_text_styles.dart';

/// Labeled numeric input for settings forms.
///
/// Two presentations, picked with [asSlider]:
/// - `false` (default): a plain bordered text field constrained to digits,
///   used for things like Tax Rate or Session Timeout.
/// - `true`: a [Slider] with a monospace value badge at the trailing edge
///   — matches the Low Stock / Critical Stock threshold controls in the
///   reference design. [badgeColor]/[badgeBackground] let a section (e.g.
///   the red "Critical Stock Level" row) recolor just the badge.
class SettingsNumberField extends StatefulWidget {
  final String label;
  final num value;
  final ValueChanged<num> onChanged;
  final String? suffix;
  final bool asSlider;
  final double min;
  final double max;
  final int? divisions;
  final Color? badgeColor;
  final Color? badgeBackground;

  const SettingsNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.suffix,
    this.asSlider = false,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.badgeColor,
    this.badgeBackground,
  });

  @override
  State<SettingsNumberField> createState() => _SettingsNumberFieldState();
}

class _SettingsNumberFieldState extends State<SettingsNumberField> {
  late final TextEditingController _controller =
      TextEditingController(text: _formatValue(widget.value));

  String _formatValue(num v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asSlider) {
      final badgeBg = widget.badgeBackground ?? context.settingsColors.primaryContainer.withOpacity(0.12);
      final badgeFg = widget.badgeColor ?? context.colors.primary;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w500,color: context.colors.secondary)),
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: badgeFg,
                    thumbColor: badgeFg,
                    inactiveTrackColor: context.colors.outlineVariant,
                    overlayColor: badgeFg.withOpacity(0.12),
                  ),
                  child: Slider(
                    value: widget.value.toDouble().clamp(widget.min, widget.max),
                    min: widget.min,
                    max: widget.max,
                    divisions: widget.divisions,
                    onChanged: (v) => widget.onChanged(v),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${_formatValue(widget.value)}${widget.suffix != null ? ' ${widget.suffix}' : ''}',
                  style: AppTextStyles.dataMono.copyWith(fontWeight: FontWeight.w700,color: context.colors.secondary),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500,color: context.colors.secondary),
        ),
        SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppTextStyles.bodyMd,
          onChanged: (text) {
            final parsed = num.tryParse(text);
            if (parsed != null) widget.onChanged(parsed);
          },
          decoration: AppDecorations.inputField().copyWith(
            suffixText: widget.suffix,
            suffixStyle: AppTextStyles.bodySm.copyWith(color: context.colors.outline),
          ),
        ),
      ],
    );
  }
}
