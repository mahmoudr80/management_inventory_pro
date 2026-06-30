import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management_inventory_pro/core/dependency_injection/service_locator.dart';
import 'package:management_inventory_pro/core/utils/app_snackBar.dart';
import 'package:management_inventory_pro/features/stock_adjustment/data/repository/stock_adjustment_repository.dart';
import '../../../product/data/respository/product_repository.dart';
import '../../../product/presentation/products/cubit/product_cubit.dart';
import '../cubit/stock_adjustment_cubit.dart';
import '../cubit/stock_adjustment_state.dart';
import '../widgets/dialogs/complete_adjustment_dialog.dart';
import '../widgets/footer/footer_actions.dart';
import '../widgets/header/adjustment_header.dart';
import '../widgets/search/product_search_section.dart';
import '../widgets/summary/impact_analysis_panel.dart';
import '../widgets/table/adjustment_table.dart';

class StockAdjustmentPage extends StatefulWidget {
  const StockAdjustmentPage({super.key});

  @override
  State<StockAdjustmentPage> createState() => _StockAdjustmentPageState();
}

class _StockAdjustmentPageState extends State<StockAdjustmentPage> {
  late final StockAdjustmentCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = StockAdjustmentCubit(getIt<StockAdjustmentRepository>())
      ..initialize();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final isCtrl =
        HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;

    if (isCtrl && event.logicalKey == LogicalKeyboardKey.keyS) {
      _cubit.saveDraft();
      return KeyEventResult.handled;
    }

    if (isCtrl && event.logicalKey == LogicalKeyboardKey.enter) {
      _cubit.requestCompleteAdjustment();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.delete) {
      final state = _cubit.state;
      if (state is StockAdjustmentLoaded && state.selectedRowId != null) {
        _cubit.removeProduct(state.selectedRowId!);
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<StockAdjustmentCubit, StockAdjustmentState>(
        listener: (context, state) {

          if (state is! StockAdjustmentLoaded) return;

          if (state.showCompleteDialog) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => CompleteAdjustmentDialog(
                onCancel: _cubit.dismissCompleteDialog,
                onConfirm: _cubit.completeAdjustment,
              ),
            );
          }

          if (state.successMessage != null) {
            Navigator.of(context).pop(); // Close the dialog

            AppSnackBar.showSuccess(
              context,
              message: state.successMessage!,
            );

            _cubit.clearSuccessMessage();
          }


          if (state.errorMessage != null) {
            Navigator.of(context).pop(); // Close the dialog
            AppSnackBar.showError(
              context,
              message: state.errorMessage!,
              duration: 2000
            );

            _cubit.clearErrorMessage();
          }
        },
        builder: (context, state) {
          return Focus(
            onKeyEvent: _handleKeyEvent,
            autofocus: true,
            child: Column(
              children: [
                if (state is StockAdjustmentLoaded)
                  AdjustmentHeader(adjustment: state.adjustment),
                const Divider(height: 1, color: Color(0xFFC3C5D9)),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //left panel
                      Expanded(
                        child: Column(
                          children: [
                            BlocProvider(
                              create: (context) =>
                                  ProductCubit(getIt<ProductRepository>())
                                    ..getProducts(),
                              child: const ProductSearchSection(),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: const AdjustmentTable(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //right panel
                      const ImpactAnalysisPanel(),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFC3C5D9)),
                const FooterActions(),
              ],
            ),
          );
        },
      ),
    );
  }
}
