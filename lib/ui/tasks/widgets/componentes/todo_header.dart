import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

enum TodoListAction { completeAll, deleteCompleted }

class TodoHeader extends StatelessWidget {
  const TodoHeader({required this.onActionSelected, super.key});

  final ValueChanged<TodoListAction> onActionSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Temporária',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          PopupMenuButton<TodoListAction>(
            tooltip: 'Ações da lista',
            onSelected: onActionSelected,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: TodoListAction.completeAll,
                child: Text('Concluir todas'),
              ),
              PopupMenuItem(
                value: TodoListAction.deleteCompleted,
                child: Text('Excluir concluídas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
