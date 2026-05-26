import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/providers/task_provider.dart';
import 'package:lr14_testing/screens/details_screen.dart';
import 'package:lr14_testing/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../../fixtures/task_fixtures.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('shows empty state when provider has no tasks', (tester) async {
      // Arrange & Act
      await _pumpHome(tester, provider: TaskProvider());

      // Assert
      expect(find.text(AppStrings.homeTitle), findsOneWidget);
      expect(find.text(AppStrings.emptyTasksTitle), findsOneWidget);
    });

    testWidgets('adds task through form and displays it', (tester) async {
      // Arrange
      await _pumpHome(tester, provider: TaskProvider());

      // Act
      await tester.enterText(find.byType(TextFormField), 'Buy milk');
      await tester.tap(find.text(AppStrings.addTask));
      await tester.pump();

      // Assert
      expect(find.text('Buy milk'), findsOneWidget);
      expect(find.text(AppStrings.emptyTasksTitle), findsNothing);
    });

    testWidgets('checkbox toggle updates task completed state', (tester) async {
      // Arrange
      await _pumpHome(
        tester,
        provider: TaskProvider(
          initialTasks: [TaskFixtures.basicTask],
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('delete button removes task from list', (tester) async {
      // Arrange
      await _pumpHome(
        tester,
        provider: TaskProvider(
          initialTasks: [TaskFixtures.basicTask],
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Assert
      expect(find.text('Task 1'), findsNothing);
      expect(find.text(AppStrings.emptyTasksTitle), findsOneWidget);
    });

    testWidgets('filter chips show completed tasks only', (tester) async {
      // Arrange
      await _pumpHome(
        tester,
        provider: TaskProvider(
          initialTasks: TaskFixtures.mixedTasks,
        ),
      );

      // Act
      await tester.tap(find.text(AppStrings.completedFilter));
      await tester.pump();

      // Assert
      expect(find.text('Active Task'), findsNothing);
      expect(find.text('Completed Task'), findsOneWidget);
    });

    testWidgets('navigates to details screen and back', (tester) async {
      // Arrange
      await _pumpHome(
        tester,
        provider: TaskProvider(
          initialTasks: [TaskFixtures.basicTask],
        ),
      );
      expect(find.text(AppStrings.homeTitle), findsOneWidget);
      expect(find.text(AppStrings.detailsTitle), findsNothing);

      // Act
      await tester.tap(find.byTooltip(AppStrings.openDetails));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.detailsTitle), findsOneWidget);
      expect(find.text(AppStrings.detailsBody), findsOneWidget);
      expect(find.text('1'), findsNWidgets(2));

      // Act (2)
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Assert (2)
      expect(find.text(AppStrings.homeTitle), findsOneWidget);
      expect(find.text(AppStrings.detailsTitle), findsNothing);
    });
  });
}

Future<void> _pumpHome(
  WidgetTester tester, {
  required TaskProvider provider,
}) async {
  addTearDown(provider.dispose);

  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          DetailsScreen.routeName: (_) => const DetailsScreen(),
        },
        initialRoute: HomeScreen.routeName,
      ),
    ),
  );
}
