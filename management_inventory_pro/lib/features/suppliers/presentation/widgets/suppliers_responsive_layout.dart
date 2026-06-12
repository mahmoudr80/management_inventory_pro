import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/sections/suppliers_list_section.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/sections/suppliers_statistics_section.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/sections/suppliers_toolbar_section.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/supplier_page_header.dart';
import 'package:management_inventory_pro/features/suppliers/presentation/widgets/supplier_top_bar.dart';

import '../cubit/suppliers_cubit.dart';
import '../cubit/suppliers_state.dart';
import 'cards/supplier_detail_card.dart';

class SuppliersResponsiveLayout extends StatelessWidget {
  const SuppliersResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1024;
        return isWide
            ? _WideLayout(constraints: constraints)
            : _NarrowLayout();
      },
    );
  }
}


// Wide layout (≥ 1024 px) — list + detail side-by-side

class _WideLayout extends StatelessWidget {
  final BoxConstraints constraints;
  const _WideLayout({required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Main content
        Expanded(
          child: _ScrollableContent(
            header: SupplierPageHeader(),
            showStats: true,
          ),
        ),
        // Detail panel
        BlocBuilder<SuppliersCubit, SuppliersState>(
          buildWhen: (prev, curr) => prev.selectedSupplier != curr.selectedSupplier,
          builder: (context, state) {
            if (state.selectedSupplier == null) return const SizedBox.shrink();
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 320,
              child: SupplierDetailCard(
                supplier: state.selectedSupplier!,
                onEdit: () => context.read<SuppliersCubit>().openEditForm(state.selectedSupplier!),
                onClose: () => context.read<SuppliersCubit>().clearSelection(),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Narrow layout (< 1024 px) — stacked

class _NarrowLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ScrollableContent(
          header:SupplierPageHeader(),
          showStats: false,
        ),
        // Bottom sheet-style detail panel
        BlocBuilder<SuppliersCubit, SuppliersState>(
          buildWhen: (prev, curr) => prev.selectedSupplier != curr.selectedSupplier,
          builder: (context, state) {
            if (state.selectedSupplier == null) return const SizedBox.shrink();
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: SupplierDetailCard(
                supplier: state.selectedSupplier!,
                onEdit: () => context
                    .read<SuppliersCubit>()
                    .openEditForm(state.selectedSupplier!),
                onClose: () => context.read<SuppliersCubit>().clearSelection(),
              ),
            );
          },
        ),
      ],
    );
  }
}


class _ScrollableContent extends StatelessWidget {
  final Widget header;
  final bool showStats;

  const _ScrollableContent({required this.header, required this.showStats});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Sticky top app bar
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(child: SupplierTopBar()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          sliver: SliverToBoxAdapter(child: header),
        ),
        if (showStats)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: const SliverToBoxAdapter(child: SuppliersStatisticsSection()),
          ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
          sliver: SliverToBoxAdapter(child: SuppliersToolbarSection()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          sliver: const SliverToBoxAdapter(child: SuppliersListSection()),
        ),
      ],
    );
  }
}


class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => false;
}