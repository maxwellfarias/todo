import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          key: const Key('add-task-button'),
          onPressed: onPressed,
          icon: const Icon(Icons.add_task_outlined),
          label: const Text('Adicionar uma tarefa'),
        ),
      ),
    );
  }
}
