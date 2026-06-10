import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_text_field.dart';
import '../product_section_card.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({super.key, required this.noteController});
final TextEditingController noteController;
  @override
  Widget build(BuildContext context) {
    return   ProductSectionCard(
      icon: Icons.notes_rounded,
      title: 'Additional notes',
      children: [
        CustomTextField(
          label: 'Internal notes',
          controller: noteController,
          maxLines: 3,
          helperText:
          'Supplier info, storage instructions, etc.',
        ),
      ],
    );
  }
}
