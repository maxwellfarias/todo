import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

class TaskEditorFields extends StatelessWidget {
  const TaskEditorFields({
    required this.descriptionController,
    required this.categoryController,
    required this.dueDate,
    required this.onPickDate,
    required this.onPickTime,
    required this.onToday,
    required this.onTomorrow,
    super.key,
  });

  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final DateTime dueDate;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onToday;
  final VoidCallback onTomorrow;

  @override
  Widget build(BuildContext context) {
    final dateLabel = _formatDate(dueDate);
    final timeLabel = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(dueDate));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            key: const Key('task-description-field'),
            controller: descriptionController,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              prefixIcon: Icon(Icons.notes),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 520;
              final category = TextFormField(
                key: const Key('task-category-field'),
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(Icons.label_outline),
                ),
              );
              final date = OutlinedButton.icon(
                key: const Key('task-date-button'),
                onPressed: onPickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(dateLabel),
              );

              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    category,
                    const SizedBox(height: AppSpacing.sm),
                    date,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: category),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: date),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ActionChip(
                key: const Key('today-chip'),
                label: const Text('Hoje'),
                onPressed: onToday,
              ),
              ActionChip(
                key: const Key('tomorrow-chip'),
                label: const Text('Amanhã'),
                onPressed: onTomorrow,
              ),
              ActionChip(
                key: const Key('time-chip'),
                avatar: const Icon(Icons.schedule),
                label: Text(timeLabel),
                onPressed: onPickTime,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'jan.',
    'fev.',
    'mar.',
    'abr.',
    'mai.',
    'jun.',
    'jul.',
    'ago.',
    'set.',
    'out.',
    'nov.',
    'dez.',
  ];
  final day = date.day.toString().padLeft(2, '0');
  return '$day ${months[date.month - 1]} ${date.year}';
}
