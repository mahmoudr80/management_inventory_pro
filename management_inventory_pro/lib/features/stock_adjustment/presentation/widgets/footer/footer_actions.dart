import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/core/theme/app_theme_extension.dart';
import 'package:management_inventory_pro/core/theme/app_dimens.dart';
import '../../cubit/stock_adjustment_cubit.dart';
import '../../cubit/stock_adjustment_state.dart';
import 'complete_adjustment_button.dart';
import 'discard_draft_button.dart';
import 'draft_status.dart';

class FooterActions extends StatelessWidget {
  const FooterActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockAdjustmentCubit, StockAdjustmentState>(
      builder: (context, state) {
        if (state is! StockAdjustmentLoaded) return const SizedBox.shrink();
        final cubit = context.read<StockAdjustmentCubit>();

        return Container(
          constraints: const BoxConstraints(minHeight: AppSize.toolbarHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(top: BorderSide(color: context.colors.outlineVariant)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Wrapped in Expanded+Wrap (not a plain Row) so the draft
              // status / divider / discard button drop to a second line
              // instead of overflowing horizontally on narrow windows.
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.sm,
                  children: [
                    DraftStatus(isSaved: state.isDraftSaved),
                    SizedBox(
                      height: 20,
                      child: VerticalDivider(color: context.colors.outlineVariant, width: 1),
                    ),
                    DiscardDraftButton(onPressed: cubit.discardDraft),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              CompleteAdjustmentButton(
                onPressed: cubit.requestCompleteAdjustment,
              ),
            ],
          ),
        );
      },
    );
  }
}