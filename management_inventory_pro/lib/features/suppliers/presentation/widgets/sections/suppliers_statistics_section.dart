import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cards/supplier_statistics_card.dart';
import '../../cubit/suppliers_cubit.dart';
import '../../cubit/suppliers_state.dart';

class SuppliersStatisticsSection extends StatelessWidget {
  const SuppliersStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliersCubit, SuppliersState>(
      buildWhen: (prev, curr) => prev.suppliers != curr.suppliers,
      builder: (context, state) {
        final total = state.suppliers.length;

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 1000 ? 2 : 3;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: crossAxisCount == 1 ? 4.8 : 2.9,
              children: [
                SupplierStatisticsCard(
                  label: 'Total Suppliers',
                  value: total.toString(),
                  icon: Icons.storefront_outlined,
                  subtitle: 'Registered in system',
                  badge: '— Steady',
                  badgeColor: AppColors.surfaceContainerHigh,
                ),
                SupplierStatisticsCard(
                  label: 'Showing',
                  value: state.filteredSuppliers.length.toString(),
                  icon: Icons.filter_list_outlined,
                  subtitle: 'Matching current filter',
                ),
                SupplierStatisticsCard(
                  label: 'Last Updated',
                  value: _lastUpdated(state),
                  icon: Icons.update_outlined,
                  subtitle: 'Most recent change',
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _lastUpdated(SuppliersState state) {
    if (state.suppliers.isEmpty) return '—';
    final latest = state.suppliers
        .map((s) => s.updatedAt??DateTime.now())
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final diff = DateTime.now().difference(latest);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
