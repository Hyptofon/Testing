import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/widgets/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('shows default empty task message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: EmptyStateWidget()));

      // Assert
      expect(find.text(AppStrings.emptyTasksTitle), findsOneWidget);
      expect(find.text(AppStrings.emptyTasksSubtitle), findsOneWidget);
      expect(find.byIcon(Icons.checklist_outlined), findsOneWidget);
    });

    testWidgets('shows custom title, subtitle, and icon', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyStateWidget(
            icon: Icons.search_off,
            title: 'Nothing found',
            subtitle: 'Try another filter.',
          ),
        ),
      );

      // Assert
      expect(find.text('Nothing found'), findsOneWidget);
      expect(find.text('Try another filter.'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });
  });
}
