import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/sales_history_cubit.dart';

class SaleSearchField extends StatelessWidget {
  const SaleSearchField({super.key,required this.searchController});
final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();
    return   Expanded(flex: 2,
      child: CustomTextField(
        label: 'search',
        hint: 'Search by Sale ID or Product Name',
        controller: searchController,
        onChanged: cubit.search,
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 5.sp,
          color: const Color(0xFF9CA3AF),
        ),
        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
          icon: Icon(Icons.close_rounded,
              size: 5.sp, color: const Color(0xFF9CA3AF)),
          onPressed: () {
            searchController.clear();
            cubit.search('');
          },
          padding: EdgeInsets.zero,
        )
            : null,
      ),
    );
  }
}
