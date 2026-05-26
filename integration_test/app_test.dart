import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:lr14_testing/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Flow', () {
    testWidgets('create a task, toggle it, and delete it', (WidgetTester tester) async {
      // Arrange
      app.main();
      await tester.pumpAndSettle();

      final titleField = find.byType(TextFormField);
      final addButton = find.byIcon(Icons.add_task_outlined);
      final taskTitle = 'Integration Test Task';

      // Act: Add Task
      await tester.enterText(titleField, taskTitle);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Assert: Task is displayed
      expect(find.text(taskTitle), findsOneWidget);

      // Arrange: Prepare to toggle
      final checkbox = find.byType(Checkbox).first;

      // Act: Toggle Task
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Assert: Task is completed (strikethrough or checked)
      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);

      // Arrange: Prepare to delete
      final deleteButton = find.byIcon(Icons.delete_outline).first;

      // Act: Delete Task
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Assert: Task is removed
      expect(find.text(taskTitle), findsNothing);
    });
  });
}
