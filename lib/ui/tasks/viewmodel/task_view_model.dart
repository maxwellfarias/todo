import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../domain/task/task_model.dart';

final class TaskViewModel extends ChangeNotifier {
  TaskViewModel({List<TaskModel>? initialTasks})
    : _tasks = List.of(initialTasks ?? _mockTasks);

  static final List<TaskModel> _mockTasks = [
    TaskModel(
      id: 1,
      title: 'Estudar Flutter',
      description: 'Estudar Flutter',
      category: 'Estudo',
      dueDate: DateTime(2026, 10, 1, 18),
    ),
    TaskModel(
      id: 2,
      title: 'Tarefa 02',
      description: '',
      category: '',
      dueDate: DateTime(2026, 10, 2, 9),
    ),
  ];

  final List<TaskModel> _tasks;

  UnmodifiableListView<TaskModel> get tasks => UnmodifiableListView(_tasks);

  int get nextId =>
      _tasks.fold(0, (maximum, task) {
        return task.id > maximum ? task.id : maximum;
      }) +
      1;

  TaskModel? taskById(int id) {
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  void createTask(TaskModel task) {
    if (task.title.trim().isEmpty) return;
    _tasks.insert(0, task.copyWith(title: task.title.trim()));
    notifyListeners();
  }

  void updateTask(TaskModel task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1 || task.title.trim().isEmpty) return;
    _tasks[index] = task.copyWith(title: task.title.trim());
    notifyListeners();
  }

  void toggleDone(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;

    final task = _tasks.removeAt(index);
    final updated = task.copyWith(isDone: !task.isDone);
    if (updated.isDone) {
      _tasks.add(updated);
    } else {
      final firstCompleted = _tasks.indexWhere((item) => item.isDone);
      _tasks.insert(
        firstCompleted == -1 ? _tasks.length : firstCompleted,
        updated,
      );
    }
    notifyListeners();
  }

  void toggleFavorite(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(
      isFavorite: !_tasks[index].isFavorite,
    );
    notifyListeners();
  }

  void deleteTask(int id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    if (_tasks.length != initialLength) notifyListeners();
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _tasks.length) return;
    if (newIndex < 0 || newIndex >= _tasks.length) return;
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    notifyListeners();
  }

  void completeAll() {
    if (_tasks.every((task) => task.isDone)) return;
    for (var index = 0; index < _tasks.length; index++) {
      _tasks[index] = _tasks[index].copyWith(isDone: true);
    }
    notifyListeners();
  }

  void deleteCompleted() {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.isDone);
    if (_tasks.length != initialLength) notifyListeners();
  }
}
