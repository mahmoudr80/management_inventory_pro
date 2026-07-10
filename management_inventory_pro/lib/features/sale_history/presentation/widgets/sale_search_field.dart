import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/sales_history_cubit.dart';

class SaleSearchField extends StatelessWidget {
  const SaleSearchField({super.key,required this.searchController});
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesHistoryCubit>();
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: searchController,
        builder: (context, value, _) {
          return CustomTextField(
            label: 'search',
            hint: 'Search by Sale ID or Product Name',
            controller: searchController,
            onChanged: cubit.search,
            prefixIcon: Icon(
              Icons.search_rounded,
              size: AppIconSize.md,
              color: context.colors.outline,
            ),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.close_rounded,
                  size: AppIconSize.md, color: context.colors.outline),
              onPressed: () {
                searchController.clear();
                cubit.search('');
              },
              padding: EdgeInsets.zero,
            )
                : null,
          );
        },
      ),
    );
  }
}