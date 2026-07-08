import 'package:flutter/material.dart';
import 'package:management_inventory_pro/core/widgets/primary_button.dart';

/// "Save Changes" action. Disabled (via [enabled]) when there's nothing
/// unsaved, and shows [PrimaryButton]'s built-in loading spinner while a
/// save is in flight.
class SaveButton extends StatelessWidget {
  final bool enabled;
  final bool isSaving;
  final VoidCallback onPressed;

  const SaveButton({
    super.key,
    required this.enabled,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled || isSaving,
        child: PrimaryButton(
          text: isSaving ? 'Saving...' : 'Save Changes',
          icon: Icons.save_outlined,
          isLoading: isSaving,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
