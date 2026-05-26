import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/models/task.dart';
import 'package:lr14_testing/widgets/task_card.dart';
import 'package:lr14_testing/widgets/task_list_widget.dart';

import '../../fixtures/task_fixtures.dart';

void main() {
  group('TaskListWidget', () {
    testWidgets('displays tasks with ListView builder', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        _wrapList(
          tasks: [
            TaskFixtures.basicTask,
            TaskFixtures.secondTask,
          ],
        ),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TaskCard), findsNWidgets(2));
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });

    testWidgets('shows empty state when task list is empty', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(_wrapList(tasks: const []));

      // Assert
      expect(find.text(AppStrings.emptyTasksTitle), findsOneWidget);
      expect(find.byType(TaskCard), findsNothing);
    });

    testWidgets('toggle callback receives task id', (tester) async {
      // Arrange
      String? toggledId;
      await tester.pumpWidget(
        _wrapList(
          tasks: [TaskFixtures.basicTask],
          onToggle: (id) {
            toggledId = id;
          },
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      expect(toggledId, '1');
    });

    testWidgets('delete callback receives task id', (tester) async {
      // Arrange
      String? deletedId;
      await tester.pumpWidget(
        _wrapList(
          tasks: [TaskFixtures.secondTask],
          onDelete: (id) {
            deletedId = id;
          },
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Assert
      expect(deletedId, '2');
    });
  });
}

Widget _wrapList({
  required List<Task> tasks,
  ValueChanged<String>? onToggle,
  ValueChanged<String>? onDelete,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        height: 480,
        child: TaskListWidget(
          tasks: tasks,
          onToggle: onToggle ?? (_) {},
          onDelete: onDelete ?? (_) {},
        ),
      ),
    ),
  );
}
