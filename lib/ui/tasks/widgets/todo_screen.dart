import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../domain/task/task_model.dart';
import '../viewmodel/task_view_model.dart';

enum _ListAction { completeAll, deleteCompleted }

enum _TaskAction { edit, delete }

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _titleFocusNode = FocusNode();

  int? _editingTaskId;
  bool _isCreating = false;
  DateTime _dueDate = DateTime.now();

  bool get _hasEditor => _isCreating || _editingTaskId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _clearEditor() {
    _editingTaskId = null;
    _isCreating = false;
    _titleController.clear();
    _descriptionController.clear();
    _categoryController.clear();
  }

  bool _commitEditor({bool collapse = true}) {
    if (!_hasEditor) return true;

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      if (_isCreating) {
        setState(_clearEditor);
        return true;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um título para a tarefa.')),
      );
      _titleFocusNode.requestFocus();
      return false;
    }

    final viewModel = context.read<TaskViewModel>();
    if (_isCreating) {
      viewModel.createTask(
        TaskModel(
          id: viewModel.nextId,
          title: title,
          description: _descriptionController.text.trim(),
          category: _categoryController.text.trim(),
          dueDate: _dueDate,
        ),
      );
    } else {
      final current = viewModel.taskById(_editingTaskId!);
      if (current != null) {
        viewModel.updateTask(
          current.copyWith(
            title: title,
            description: _descriptionController.text.trim(),
            category: _categoryController.text.trim(),
            dueDate: _dueDate,
          ),
        );
      }
    }

    if (collapse) setState(_clearEditor);
    return true;
  }

  void _beginCreate() {
    if (!_commitEditor()) return;
    final now = DateTime.now();
    setState(() {
      _isCreating = true;
      _editingTaskId = null;
      _titleController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      _dueDate = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    });
    _requestTitleFocus();
  }

  void _beginEdit(TaskModel task) {
    if (_editingTaskId == task.id && !_isCreating) return;
    if (!_commitEditor()) return;
    setState(() {
      _isCreating = false;
      _editingTaskId = task.id;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _categoryController.text = task.category;
      _dueDate = task.dueDate;
    });
    _requestTitleFocus();
  }

  void _requestTitleFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _titleFocusNode.requestFocus();
    });
  }

  void _toggleDone(TaskModel task) {
    if (_editingTaskId == task.id && !_commitEditor()) return;
    context.read<TaskViewModel>().toggleDone(task.id);
  }

  void _reorderTask(int oldIndex, int newIndex) {
    // ReorderableListView invokes this callback before it removes its drag
    // overlay. Rebuilding an open editor at that point mutates LayoutBuilder
    // while the overlay is still performing layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _commitEditor();
      context.read<TaskViewModel>().reorderTask(oldIndex, newIndex);
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Selecionar vencimento',
    );
    if (date == null || !mounted) return;
    setState(() {
      _dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        _dueDate.hour,
        _dueDate.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate),
      helpText: 'Selecionar horário',
    );
    if (time == null || !mounted) return;
    setState(() {
      _dueDate = DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _useRelativeDate(int daysFromToday) {
    final target = DateTime.now().add(Duration(days: daysFromToday));
    setState(() {
      _dueDate = DateTime(
        target.year,
        target.month,
        target.day,
        _dueDate.hour,
        _dueDate.minute,
      );
    });
  }

  Future<bool> _confirmDelete(String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Excluir'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteTask(TaskModel task) async {
    final confirmed = await _confirmDelete('Excluir “${task.title}”?');
    if (!confirmed || !mounted) return;
    if (_editingTaskId == task.id) setState(_clearEditor);
    context.read<TaskViewModel>().deleteTask(task.id);
  }

  Future<void> _deleteCompleted() async {
    final viewModel = context.read<TaskViewModel>();
    if (!viewModel.tasks.any((task) => task.isDone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há tarefas concluídas.')),
      );
      return;
    }
    final confirmed = await _confirmDelete(
      'Excluir todas as tarefas concluídas?',
    );
    if (!confirmed || !mounted) return;
    setState(_clearEditor);
    viewModel.deleteCompleted();
  }

  void _handleListAction(_ListAction action) {
    switch (action) {
      case _ListAction.completeAll:
        _commitEditor();
        context.read<TaskViewModel>().completeAll();
      case _ListAction.deleteCompleted:
        _deleteCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TaskViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _commitEditor();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
              return SingleChildScrollView(
                padding: EdgeInsets.all(
                  isTablet ? AppSpacing.xl : AppSpacing.sm,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.todoMaxWidth,
                    ),
                    child: Card.outlined(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? AppSpacing.lg : AppSpacing.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Temporária',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                    ),
                                  ),
                                  PopupMenuButton<_ListAction>(
                                    tooltip: 'Ações da lista',
                                    onSelected: _handleListAction,
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: _ListAction.completeAll,
                                        child: Text('Concluir todas'),
                                      ),
                                      PopupMenuItem(
                                        value: _ListAction.deleteCompleted,
                                        child: Text('Excluir concluídas'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  key: const Key('add-task-button'),
                                  onPressed: _beginCreate,
                                  icon: const Icon(Icons.add_task_outlined),
                                  label: const Text('Adicionar uma tarefa'),
                                ),
                              ),
                            ),
                            if (_isCreating)
                              _NewTaskEditor(
                                titleController: _titleController,
                                titleFocusNode: _titleFocusNode,
                                editor: _buildEditorFields(),
                                onSubmitted: (_) => _commitEditor(),
                              ),
                            if (viewModel.tasks.isEmpty && !_isCreating)
                              Padding(
                                padding: const EdgeInsets.all(AppSpacing.xl),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.task_alt,
                                      size: 48,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Nenhuma tarefa por aqui',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              )
                            else
                              ReorderableListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                buildDefaultDragHandles: false,
                                itemCount: viewModel.tasks.length,
                                onReorderItem: _reorderTask,
                                itemBuilder: (context, index) {
                                  final task = viewModel.tasks[index];
                                  final isEditing =
                                      _editingTaskId == task.id && !_isCreating;
                                  return _TaskRow(
                                    key: ValueKey(task.id),
                                    index: index,
                                    task: task,
                                    isEditing: isEditing,
                                    titleController: isEditing
                                        ? _titleController
                                        : null,
                                    titleFocusNode: isEditing
                                        ? _titleFocusNode
                                        : null,
                                    editor: isEditing
                                        ? _buildEditorFields()
                                        : null,
                                    onOpen: () => _beginEdit(task),
                                    onSubmitted: (_) => _commitEditor(),
                                    onDone: () => _toggleDone(task),
                                    onFavorite: () =>
                                        viewModel.toggleFavorite(task.id),
                                    onMenuSelected: (action) {
                                      switch (action) {
                                        case _TaskAction.edit:
                                          _beginEdit(task);
                                        case _TaskAction.delete:
                                          _deleteTask(task);
                                      }
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEditorFields() {
    return _TaskEditorFields(
      descriptionController: _descriptionController,
      categoryController: _categoryController,
      dueDate: _dueDate,
      onPickDate: _pickDate,
      onPickTime: _pickTime,
      onToday: () => _useRelativeDate(0),
      onTomorrow: () => _useRelativeDate(1),
    );
  }
}

class _NewTaskEditor extends StatelessWidget {
  const _NewTaskEditor({
    required this.titleController,
    required this.titleFocusNode,
    required this.editor,
    required this.onSubmitted,
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

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    super.key,
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
  final ValueChanged<_TaskAction> onMenuSelected;

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
              PopupMenuButton<_TaskAction>(
                key: Key('task-menu-${task.id}'),
                tooltip: 'Ações da tarefa',
                onSelected: onMenuSelected,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: _TaskAction.edit, child: Text('Editar')),
                  PopupMenuItem(
                    value: _TaskAction.delete,
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
        Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md),
      ],
    );
  }
}

class _TaskEditorFields extends StatelessWidget {
  const _TaskEditorFields({
    required this.descriptionController,
    required this.categoryController,
    required this.dueDate,
    required this.onPickDate,
    required this.onPickTime,
    required this.onToday,
    required this.onTomorrow,
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
