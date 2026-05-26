import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/models/task.dart';
import 'package:lr14_testing/widgets/task_card.dart';

import '../../fixtures/task_fixtures.dart';

void main() {
  group('TaskCard Widget', () {
    late Task testTask;

    setUp(() {
      testTask = TaskFixtures.basicTask;
    });

    testWidgets('displays task title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(_wrapTaskCard(task: testTask));

      // Assert
      expect(find.text('Task 1'), findsOneWidget);
    });

    testWidgets('displays checkbox and delete button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(_wrapTaskCard(task: testTask));

      // Assert
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('checkbox reflects completed state', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        _wrapTaskCard(task: testTask.copyWith(isCompleted: true)),
      );

      // Assert
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('checkbox tap calls onToggle', (tester) async {
      // Arrange
      var didToggle = false;
      await tester.pumpWidget(
        _wrapTaskCard(
          task: testTask,
          onToggle: () {
            didToggle = true;
          },
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      expect(didToggle, isTrue);
    });

    testWidgets('delete button tap calls onDelete', (tester) async {
      // Arrange
      var didDelete = false;
      await tester.pumpWidget(
        _wrapTaskCard(
          task: testTask,
          onDelete: () {
            didDelete = true;
          },
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Assert
      expect(didDelete, isTrue);
    });

    testWidgets('completed task shows strikethrough title', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        _wrapTaskCard(task: testTask.copyWith(isCompleted: true)),
      );

      // Assert
      final text = tester.widget<Text>(find.text('Task 1'));
      expect(text.style?.decoration, TextDecoration.lineThrough);
    });
  });
}

Widget _wrapTaskCard({
  required Task task,
  VoidCallback? onToggle,
  VoidCallback? onDelete,
}) {
  return MaterialApp(
    home: Scaffold(
      body: TaskCard(
        task: task,
        onToggle: onToggle ?? () {},
        onDelete: onDelete ?? () {},
      ),
    ),
  );
}
