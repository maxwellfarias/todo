import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

class NewTaskEditor extends StatelessWidget {
  const NewTaskEditor({
    required this.titleController,
    required this.titleFocusNode,
    required this.editor,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController titleController;
  final FocusNode titleFocusNode;
  final Widget editor;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      key: const Key('new-task-editor'),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TextFormField(
              key: const Key('new-task-title'),
              controller: titleController,
              focusNode: titleFocusNode,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.radio_button_unchecked),
              ),
              onFieldSubmitted: onSubmitted,
            ),
            editor,
          ],
        ),
      ),
    );
  }
}
