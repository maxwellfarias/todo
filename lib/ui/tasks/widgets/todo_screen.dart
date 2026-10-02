import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../domain/task/task_model.dart';
import '../viewmodel/task_view_model.dart';
import 'componentes/add_task_button.dart';
import 'componentes/empty_task_list.dart';
import 'componentes/new_task_editor.dart';
import 'componentes/task_editor_fields.dart';
import 'componentes/task_row.dart';
import 'componentes/todo_header.dart';

class TodoScreen extends StatefulWidget {
  final TaskViewModel viewModel;
  const TodoScreen({required this.viewModel, super.key});

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

    if (_isCreating) {
      widget.viewModel.createTask(
        TaskModel(
          id: widget.viewModel.nextId,
          title: title,
          description: _descriptionController.text.trim(),
          category: _categoryController.text.trim(),
          dueDate: _dueDate,
        ),
      );
    } else {
      final current = widget.viewModel.taskById(_editingTaskId!);
      if (current != null) {
        widget.viewModel.updateTask(
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
    widget.viewModel.toggleDone(task.id);
  }

  void _reorderTask(int oldIndex, int newIndex) {
    // ReorderableListView invokes this callback before fully removing its drag
    // overlay. Close the editor after that frame, then reorder only after the
    // editor's rebuild has also completed. Keeping those mutations in separate
    // frames prevents the overlay from being reparented during layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_commitEditor()) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.viewModel.reorderTask(oldIndex, newIndex);
      });
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
    widget.viewModel.deleteTask(task.id);
  }

  Future<void> _deleteCompleted() async {
    if (!widget.viewModel.tasks.any((task) => task.isDone)) {
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
    widget.viewModel.deleteCompleted();
  }

  void _handleListAction(TodoListAction action) {
    switch (action) {
      case TodoListAction.completeAll:
        _commitEditor();
        widget.viewModel.completeAll();
      case TodoListAction.deleteCompleted:
        _deleteCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;

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
                  final isTablet =
                      constraints.maxWidth >= AppBreakpoints.tablet;
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
                              vertical: isTablet
                                  ? AppSpacing.lg
                                  : AppSpacing.md,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TodoHeader(onActionSelected: _handleListAction),
                                const SizedBox(height: AppSpacing.sm),
                                AddTaskButton(onPressed: _beginCreate),
                                if (_isCreating)
                                  NewTaskEditor(
                                    titleController: _titleController,
                                    titleFocusNode: _titleFocusNode,
                                    editor: _buildEditorFields(),
                                    onSubmitted: (_) => _commitEditor(),
                                  ),
                                if (viewModel.tasks.isEmpty && !_isCreating)
                                  const EmptyTaskList()
                                else
                                  ReorderableListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    buildDefaultDragHandles: false,
                                    itemCount: viewModel.tasks.length,
                                    onReorderItem: _reorderTask,
                                    itemBuilder: (context, index) {
                                      final task = viewModel.tasks[index];
                                      final isEditing =
                                          _editingTaskId == task.id &&
                                          !_isCreating;
                                      return TaskRow(
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
                                            case TaskAction.edit:
                                              _beginEdit(task);
                                            case TaskAction.delete:
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
      },
    );
  }

  Widget _buildEditorFields() {
    return TaskEditorFields(
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
