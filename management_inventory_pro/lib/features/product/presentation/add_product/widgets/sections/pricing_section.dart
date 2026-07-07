import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_text_field.dart';
import '../product_section_card.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({
    super.key,
    required this.costPriceController,
    required this.sellingPriceController,
    required this.marginCard,
  });

  final TextEditingController costPriceController;
  final TextEditingController sellingPriceController;
  final Widget marginCard;

  @override
  Widget build(BuildContext context) {
    return ProductSectionCard(
      icon: Icons.attach_money_rounded,
      title: 'Pricing',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Cost price',
                controller: costPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextField(
                label: 'Selling price',
                controller: sellingPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixText: '\$ ',
              ),
            ),
          ],
        ),
        marginCard,
      ],
    );
  }
}
