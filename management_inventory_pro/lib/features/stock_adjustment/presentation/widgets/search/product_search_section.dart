import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/adjustment_reason.dart';
import '../../../data/models/stock_adjustment_item_model.dart';
import '../../cubit/stock_adjustment_cubit.dart';
import '../../cubit/stock_adjustment_state.dart';
import 'reason_dropdown.dart';
import 'search_field.dart';

class ProductSearchSection extends StatefulWidget {
  const ProductSearchSection({super.key});

  @override
  State<ProductSearchSection> createState() => _ProductSearchSectionState();
}

class _ProductSearchSectionState extends State<ProductSearchSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch(StockAdjustmentCubit cubit) {
    _controller.clear();
    cubit.clearSearch();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StockAdjustmentCubit>();

    return BlocBuilder<StockAdjustmentCubit, StockAdjustmentState>(
      builder: (context, state) {
        final loaded = state is StockAdjustmentLoaded ? state : null;
        final results = loaded?.searchResults ?? [];
        final reason = loaded?.adjustment.reason;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: SearchField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: cubit.searchProducts,
                      onClear: () => _clearSearch(cubit),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  ReasonDropdown(
                    selected: reason,
                    onChanged: cubit.updateReason,
                  ),
                ],
              ),
            ),
            if (results.isNotEmpty)
              _SearchResultsOverlay(
                results: results,
                onSelect: (p) {
                  cubit.addProduct(p);
                  _clearSearch(cubit);
                },
              ),
          ],
        );
      },
    );
  }
}

class _SearchResultsOverlay extends StatelessWidget {
  final List<StockAdjustmentItemModel> results;
  final ValueChanged<StockAdjustmentItemModel> onSelect;

  const _SearchResultsOverlay({required this.results, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      constraints: BoxConstraints(maxHeight: 300.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFC3C5D9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          _SearchResultsHeader(),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: results.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFC3C5D9)),
              itemBuilder: (_, i) =>
                  _SearchResultRow(product: results[i], onSelect: onSelect),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: Color(0xFFEAEDFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          SizedBox(width: 2.w),
          Expanded(
            flex: 3,
            child: _HeaderLabel('PRODUCT'),
          ),
          Expanded(
            flex: 2,
            child: _HeaderLabel('SKU / BARCODE'),
          ),
          _HeaderLabel('STOCK', textAlign: TextAlign.right),
          SizedBox(width: 2.w),
        ],
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const _HeaderLabel(this.text, {this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: 5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.05,
        color: const Color(0xFF434656),
      ),
    );
  }
}

class _SearchResultRow extends StatelessWidget {
  final StockAdjustmentItemModel product;
  final ValueChanged<StockAdjustmentItemModel> onSelect;

  const _SearchResultRow({required this.product, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(product),
      hoverColor: const Color(0xFFEAEDFF),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 10.h),
        child: Row(
          children: [
            // Container(
            //   width: 2.w,
            //   height: 36.h,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFFEAEDFF),
            //     borderRadius: BorderRadius.circular(4.r),
            //     border: Border.all(color: const Color(0xFFC3C5D9)),
            //   ),
            //   child: Icon(Icons.image_outlined,
            //       size: 28.r, color: const Color(0xFF737688)),
            // ),
            Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: 30.r,
            ),
            SizedBox(width: 2.w),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyle(
                      fontSize: 5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF131B2E),
                    ),
                  ),
                  Text(
                    product.category??'',
                    style: TextStyle(
                        fontSize: 5.sp, color: const Color(0xFF434656)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.sku,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 5.sp,
                      color: const Color(0xFF131B2E),
                    ),
                  ),
                  Text(
                    product.barcode??'',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 5.sp,
                      color: const Color(0xFF737688),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${product.currentStock}',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF131B2E),
              ),
            ),
            SizedBox(width: 2.w),
            Icon(Icons.add_circle_outline,
                size: 28.r, color: const Color(0xFF0041C8)),
          ],
        ),
      ),
    );
  }
}
