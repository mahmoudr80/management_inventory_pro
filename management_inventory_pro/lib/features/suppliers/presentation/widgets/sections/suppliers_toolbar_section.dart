import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme_extension.dart';
import '../../../../../core/theme/app_decoration.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../cubit/suppliers_cubit.dart';
import '../../cubit/suppliers_state.dart';

class SuppliersToolbarSection extends StatefulWidget {
  const SuppliersToolbarSection({super.key});

  @override
  State<SuppliersToolbarSection> createState() => _SuppliersToolbarSectionState();
}

class _SuppliersToolbarSectionState extends State<SuppliersToolbarSection> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuppliersCubit, SuppliersState>(
      buildWhen: (prev, curr) =>
      prev.searchQuery != curr.searchQuery ||
          prev.filteredSuppliers.length != curr.filteredSuppliers.length,
      builder: (context, state) {
        return Row(
          children: [
            // Search field
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                style: AppTextStyles.bodyMd,
                onChanged: context.read<SuppliersCubit>().search,
                decoration: AppDecorations.searchField(
                  hint: 'Search suppliers by name, email, phone…',
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(Icons.search, size: 18, color: context.colors.outline),
                  ),
                  suffix: state.searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.close, size: 16, color: context.colors.outline),
                    onPressed: () {
                      _searchCtrl.clear();
                      context.read<SuppliersCubit>().clearSearch();
                    },
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Result count chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.outlineVariant),
              ),
              child: Text(
                '${state.filteredSuppliers.length} of ${state.suppliers.length}',
                style: AppTextStyles.labelCaps,
              ),
            ),
          ],
        );
      },
    );
  }
}