import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/theme/app_theme.dart';
import 'package:todo/ui/tasks/viewmodel/task_view_model.dart';
import 'package:todo/ui/tasks/widgets/todo_screen.dart';

void main() {
  testWidgets('estado compacto em tema escuro', (tester) async {
    await tester.binding.setSurfaceSize(const Size(378, 520));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_goldenApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(TodoScreen),
      matchesGoldenFile('goldens/todo_compact_dark.png'),
    );
  });

  testWidgets('estado expandido em tema escuro', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 959));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_goldenApp());
    await tester.tap(find.text('Estudar Flutter').first);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(TodoScreen),
      matchesGoldenFile('goldens/todo_expanded_dark.png'),
    );
  });
}

Widget _goldenApp() {
  return ChangeNotifierProvider(
    create: (_) => TaskViewModel(),
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
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
