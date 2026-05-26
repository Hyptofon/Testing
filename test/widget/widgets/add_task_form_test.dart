import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/widgets/add_task_form.dart';

void main() {
  group('AddTaskForm Widget', () {
    testWidgets('displays text field and submit button', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(_wrapForm(onSubmit: (_) {}));

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text(AppStrings.addTask), findsOneWidget);
    });

    testWidgets('shows validation error for empty title', (tester) async {
      // Arrange
      await tester.pumpWidget(_wrapForm(onSubmit: (_) {}));

      // Act
      await tester.tap(find.text(AppStrings.addTask));
      await tester.pump();

      // Assert
      expect(find.text(AppStrings.titleEmptyError), findsOneWidget);
    });

    testWidgets('shows validation error for short title', (tester) async {
      // Arrange
      await tester.pumpWidget(_wrapForm(onSubmit: (_) {}));

      // Act
      await tester.enterText(find.byType(TextFormField), 'No');
      await tester.tap(find.text(AppStrings.addTask));
      await tester.pump();

      // Assert
      expect(find.text(AppStrings.titleShortError), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      // Arrange
      await tester.pumpWidget(_wrapForm(onSubmit: (_) {}));

      // Act
      await tester.enterText(find.byType(TextFormField), 'New Task');
      await tester.pump();

      // Assert
      expect(find.text('New Task'), findsOneWidget);
    });

    testWidgets('calls onSubmit with trimmed valid title', (tester) async {
      // Arrange
      String? submittedTitle;
      await tester.pumpWidget(
        _wrapForm(
          onSubmit: (title) {
            submittedTitle = title;
          },
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), ' Valid Task ');
      await tester.tap(find.text(AppStrings.addTask));
      await tester.pump();

      // Assert
      expect(submittedTitle, 'Valid Task');
    });

    testWidgets('clears field after successful submit', (tester) async {
      // Arrange
      await tester.pumpWidget(_wrapForm(onSubmit: (_) {}));

      // Act
      await tester.enterText(find.byType(TextFormField), 'Task');
      await tester.tap(find.text(AppStrings.addTask));
      await tester.pump();

      // Assert
      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller?.text, isEmpty);
    });
  });
}

Widget _wrapForm({required ValueChanged<String> onSubmit}) {
  return MaterialApp(
    home: Scaffold(body: AddTaskForm(onSubmit: onSubmit)),
  );
}
