import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/theme/app_theme.dart';
import 'package:todo/ui/tasks/viewmodel/task_view_model.dart';
import 'package:todo/ui/tasks/widgets/todo_screen.dart';

void main() {
  testWidgets('exibe os dados mockados e abre o editor inline', (tester) async {
    final viewModel = TaskViewModel();
    await tester.pumpWidget(_testApp(viewModel));

    expect(find.text('Temporária'), findsOneWidget);
    expect(find.text('Estudar Flutter'), findsWidgets);
    expect(find.text('Tarefa 02'), findsOneWidget);

    await tester.tap(find.text('Estudar Flutter').first);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task-description-field')), findsOneWidget);
    expect(find.text('Hoje'), findsOneWidget);
    expect(find.text('Amanhã'), findsOneWidget);
    expect(find.text('01 out. 2026'), findsOneWidget);
  });

  testWidgets('cria tarefa e descarta rascunho vazio', (tester) async {
    final viewModel = TaskViewModel();
    await tester.pumpWidget(_testApp(viewModel));

    await tester.tap(find.byKey(const Key('add-task-button')));
    await tester.pump();
    expect(find.byKey(const Key('new-task-editor')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('new-task-title')),
      'Comprar pão',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(viewModel.tasks.first.title, 'Comprar pão');
    expect(find.byKey(const Key('new-task-editor')), findsNothing);

    await tester.tap(find.byKey(const Key('add-task-button')));
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(viewModel.tasks, hasLength(3));
  });

  testWidgets('conclui e favorita uma tarefa', (tester) async {
    final viewModel = TaskViewModel();
    await tester.pumpWidget(_testApp(viewModel));

    await tester.tap(find.byKey(const Key('task-favorite-1')));
    await tester.pump();
    expect(viewModel.taskById(1)!.isFavorite, isTrue);

    await tester.tap(find.byKey(const Key('task-checkbox-1')));
    await tester.pumpAndSettle();
    expect(viewModel.tasks.last.id, 1);
    expect(viewModel.tasks.last.isDone, isTrue);
  });

  testWidgets('reordena tarefas sem alterar a árvore durante o layout', (
    tester,
  ) async {
    final viewModel = TaskViewModel();
    await tester.pumpWidget(_testApp(viewModel));

    await tester.tap(find.text('Estudar Flutter').first);
    await tester.pumpAndSettle();

    await tester.drag(
      find.byIcon(Icons.drag_indicator).first,
      const Offset(0, 400),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(viewModel.tasks.map((task) => task.id), [2, 1]);
    expect(find.byKey(const Key('task-description-field')), findsNothing);
  });

  testWidgets('exclui tarefa somente após confirmação', (tester) async {
    final viewModel = TaskViewModel();
    await tester.pumpWidget(_testApp(viewModel));

    await tester.tap(find.byKey(const Key('task-menu-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir').last);
    await tester.pumpAndSettle();

    expect(find.text('Confirmar exclusão'), findsOneWidget);
    expect(viewModel.tasks, hasLength(2));

    await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
    await tester.pumpAndSettle();

    expect(viewModel.tasks, hasLength(1));
    expect(viewModel.taskById(1), isNull);
  });

  testWidgets('atalho Amanhã preserva o horário', (tester) async {
    final viewModel = TaskViewModel();
    await tester.pumpWidget(_testApp(viewModel));

    await tester.tap(find.text('Estudar Flutter').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tomorrow-chip')));
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final saved = viewModel.taskById(1)!;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    expect(saved.dueDate.year, tomorrow.year);
    expect(saved.dueDate.month, tomorrow.month);
    expect(saved.dueDate.day, tomorrow.day);
    expect(saved.dueDate.hour, 18);
  });

  testWidgets('não apresenta overflow em tamanhos mobile e desktop', (
    tester,
  ) async {
    for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
      for (final size in [const Size(378, 700), const Size(1600, 959)]) {
        await tester.binding.setSurfaceSize(size);
        await tester.pumpWidget(
          _testApp(TaskViewModel(), themeMode: themeMode),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    }
    await tester.binding.setSurfaceSize(null);
  });
}

Widget _testApp(
  TaskViewModel viewModel, {
  ThemeMode themeMode = ThemeMode.dark,
}) {
  return ChangeNotifierProvider.value(
    value: viewModel,
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const TodoScreen(),
    ),
  );
}
