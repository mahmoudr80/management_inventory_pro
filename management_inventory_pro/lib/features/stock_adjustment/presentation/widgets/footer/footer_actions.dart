import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFC3C5D9))),
          ),
          child: Row(
            children: [
              DraftStatus(isSaved: state.isDraftSaved),
              SizedBox(width: 2.w),
              const VerticalDivider(color: Color(0xFFC3C5D9), width: 1),
              SizedBox(width: 2.w),
              DiscardDraftButton(onPressed: cubit.discardDraft),
              const Spacer(),
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
