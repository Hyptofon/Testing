import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/models/task.dart';
import 'package:lr14_testing/theme/app_theme.dart';
import 'package:lr14_testing/widgets/task_card.dart';

void main() {
  group('Golden Tests (Variant B)', () {
    testWidgets('TaskCard golden test', (WidgetTester tester) async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Golden Task',
        createdAt: DateTime(2026, 1, 1),
      );

      final widget = MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: TaskCard(task: task, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      await expectLater(
        find.byType(TaskCard),
        matchesGoldenFile('goldens/task_card_light.png'),
      );
    });

    testWidgets('TaskCard completed golden test', (WidgetTester tester) async {
      // Arrange
      final task = Task(
        id: '2',
        title: 'Completed Golden Task',
        isCompleted: true,
        createdAt: DateTime(2026, 1, 1),
      );

      final widget = MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: TaskCard(task: task, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      await expectLater(
        find.byType(TaskCard),
        matchesGoldenFile('goldens/task_card_completed_light.png'),
      );
    });
  });
}
