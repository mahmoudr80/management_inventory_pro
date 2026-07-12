import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Shared loading placeholder for chart areas, tables, or a whole
/// workspace while a report query is in flight.
class ReportLoadingState extends StatelessWidget {
  const ReportLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: context.colors.primary),
      ),
    );
  }
}
