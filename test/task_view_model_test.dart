import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/task/task_model.dart';
import 'package:todo/ui/tasks/viewmodel/task_view_model.dart';

void main() {
  group('TaskViewModel', () {
    test('inicia com as tarefas mockadas', () {
      final viewModel = TaskViewModel();

      expect(viewModel.tasks, hasLength(2));
      expect(viewModel.tasks.first.title, 'Estudar Flutter');
      expect(viewModel.tasks.last.title, 'Tarefa 02');
    });

    test('cria, atualiza e exclui uma tarefa', () {
      final viewModel = TaskViewModel(initialTasks: []);
      final task = TaskModel(
        id: viewModel.nextId,
        title: '  Nova tarefa  ',
        description: '',
        category: '',
        dueDate: DateTime(2026, 10, 1),
      );

      viewModel.createTask(task);
      expect(viewModel.tasks.single.title, 'Nova tarefa');

      viewModel.updateTask(
        viewModel.tasks.single.copyWith(
          title: 'Atualizada',
          category: 'Pessoal',
        ),
      );
      expect(viewModel.tasks.single.title, 'Atualizada');
      expect(viewModel.tasks.single.category, 'Pessoal');

      viewModel.deleteTask(viewModel.tasks.single.id);
      expect(viewModel.tasks, isEmpty);
    });

    test('ignora títulos vazios', () {
      final viewModel = TaskViewModel(initialTasks: []);

      viewModel.createTask(
        TaskModel(
          id: 1,
          title: '   ',
          description: '',
          category: '',
          dueDate: DateTime(2026),
        ),
      );

      expect(viewModel.tasks, isEmpty);
    });

    test(
      'concluir move a tarefa para o fim e desfazer retorna aos pendentes',
      () {
        final viewModel = TaskViewModel();

        viewModel.toggleDone(1);
        expect(viewModel.tasks.last.id, 1);
        expect(viewModel.tasks.last.isDone, isTrue);

        viewModel.toggleDone(1);
        expect(
          viewModel.tasks.firstWhere((task) => task.id == 1).isDone,
          isFalse,
        );
        expect(viewModel.tasks.last.isDone, isFalse);
      },
    );

    test('alterna favorito e reordena', () {
      final viewModel = TaskViewModel();

      viewModel.toggleFavorite(1);
      expect(viewModel.taskById(1)!.isFavorite, isTrue);

      viewModel.reorderTask(0, 1);
      expect(viewModel.tasks.map((task) => task.id), [2, 1]);
    });

    test('conclui todas e exclui concluídas', () {
      final viewModel = TaskViewModel();

      viewModel.completeAll();
      expect(viewModel.tasks.every((task) => task.isDone), isTrue);

      viewModel.deleteCompleted();
      expect(viewModel.tasks, isEmpty);
    });

    test('expõe a coleção sem permitir mutação externa', () {
      final viewModel = TaskViewModel();

      expect(
        () => viewModel.tasks.add(viewModel.tasks.first),
        throwsUnsupportedError,
      );
    });
  });
}
