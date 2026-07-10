import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../home/cubit/home_cubit.dart';
import '../../../data/models/top_selling_product.dart';
import '../common/dashboard_card.dart';
import '../common/loading_card.dart';
import '../common/section_header.dart';
import 'top_selling_table.dart';

class TopSellingSection extends StatelessWidget {
  const TopSellingSection({
    super.key,
    required this.products,
    required this.isLoading,
  });

  final List<TopSellingProductRef> products;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return const LoadingCard(height: 260);
    }

    return DashboardCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SectionHeader(
              title: 'Top Selling Products',
              trailing: TextButton(
                onPressed: ()=> context.read<HomeCubit>().openProductList(),
                child: const Text('View All'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TopSellingTable(products: products),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
