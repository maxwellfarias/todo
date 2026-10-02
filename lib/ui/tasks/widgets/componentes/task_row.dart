import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../domain/task/task_model.dart';

enum TaskAction { edit, delete }

class TaskRow extends StatelessWidget {
  const TaskRow({
    required this.index,
    required this.task,
    required this.isEditing,
    required this.titleController,
    required this.titleFocusNode,
    required this.editor,
    required this.onOpen,
    required this.onSubmitted,
    required this.onDone,
    required this.onFavorite,
    required this.onMenuSelected,
    super.key,
  });

  final int index;
  final TaskModel task;
  final bool isEditing;
  final TextEditingController? titleController;
  final FocusNode? titleFocusNode;
  final Widget? editor;
  final VoidCallback onOpen;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onDone;
  final VoidCallback onFavorite;
  final ValueChanged<TaskAction> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mutedColor = colorScheme.onSurfaceVariant;

    return Column(
      children: [
        Material(
          color: isEditing
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surface.withValues(alpha: 0),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.sm),
                  child: Tooltip(
                    message: 'Reordenar tarefa',
                    child: Icon(Icons.drag_indicator),
                  ),
                ),
              ),
              Checkbox(
                key: Key('task-checkbox-${task.id}'),
                value: task.isDone,
                onChanged: (_) => onDone(),
              ),
              Expanded(
                child: isEditing
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: TextFormField(
                          key: Key('task-title-${task.id}'),
                          controller: titleController,
                          focusNode: titleFocusNode,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                          ),
                          onFieldSubmitted: onSubmitted,
                        ),
                      )
                    : ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: onOpen,
                        title: Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isDone ? mutedColor : null,
                              ),
                        ),
                        subtitle: task.description.isEmpty
                            ? null
                            : Text(
                                task.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: mutedColor),
                              ),
                      ),
              ),
              IconButton(
                key: Key('task-favorite-${task.id}'),
                tooltip: task.isFavorite
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
                onPressed: onFavorite,
                icon: Icon(
                  task.isFavorite ? Icons.star : Icons.star_border,
                  color: task.isFavorite ? colorScheme.primary : null,
                ),
              ),
              PopupMenuButton<TaskAction>(
                key: Key('task-menu-${task.id}'),
                tooltip: 'Ações da tarefa',
                onSelected: onMenuSelected,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: TaskAction.edit, child: Text('Editar')),
                  PopupMenuItem(
                    value: TaskAction.delete,
                    child: Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: isEditing
              ? ColoredBox(
                  color: colorScheme.surfaceContainerHigh,
                  child: editor!,
                )
              : const SizedBox.shrink(),
        ),
        const Divider(
          height: 1,
          indent: AppSpacing.md,
          endIndent: AppSpacing.md,
        ),
      ],
    );
  }
}
