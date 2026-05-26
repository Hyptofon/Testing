import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/models/task.dart';
import 'package:lr14_testing/models/task_action_result.dart';
import 'package:lr14_testing/providers/task_provider.dart';

import '../../fixtures/task_fixtures.dart';

void main() {
  group('TaskProvider', () {
    late TaskProvider provider;

    setUp(() {
      provider = TaskProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    test('initial state is empty with all filter selected', () {
      // Assert
      expect(provider.tasks, isEmpty);
      expect(provider.allTasks, isEmpty);
      expect(provider.filter, TaskFilter.all);
      expect(provider.totalCount, 0);
    });

    test('addTask adds task to list and notifies listeners', () {
      // Arrange
      var didNotify = false;
      provider.addListener(() {
        didNotify = true;
      });

      // Act
      provider.addTask(TaskFixtures.basicTask);

      // Assert
      expect(provider.tasks.length, 1);
      expect(provider.tasks.single.id, '1');
      expect(didNotify, isTrue);
    });

    test('createTask returns success and stores trimmed task title', () {
      // Act
      final result = provider.createTask(title: ' New Task ');

      // Assert
      expect(result, isA<TaskActionSuccess>());
      expect(provider.tasks.single.title, 'New Task');
    });

    test('createTask returns failure for invalid title', () {
      // Act
      final result = provider.createTask(title: '');

      // Assert
      expect(result, isA<TaskActionFailure>());
      expect((result as TaskActionFailure).message, AppStrings.titleEmptyError);
      expect(provider.tasks, isEmpty);
    });

    test('removeTask removes existing task and notifies listeners', () {
      // Arrange
      var notificationCount = 0;
      provider
        ..addTask(TaskFixtures.basicTask)
        ..addTask(TaskFixtures.secondTask)
        ..addListener(() {
          notificationCount++;
        });

      // Act
      final didRemove = provider.removeTask('1');

      // Assert
      expect(didRemove, isTrue);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.single.id, '2');
      expect(notificationCount, 1);
    });

    test('removeTask returns false and does not notify for missing task', () {
      // Arrange
      var didNotify = false;
      provider.addListener(() {
        didNotify = true;
      });

      // Act
      final didRemove = provider.removeTask('missing');

      // Assert
      expect(didRemove, isFalse);
      expect(didNotify, isFalse);
    });

    test('toggleTask changes completed status twice', () {
      // Arrange
      provider.addTask(TaskFixtures.basicTask);

      // Act
      final firstToggle = provider.toggleTask('1');

      // Assert
      expect(firstToggle, isTrue);
      expect(provider.tasks.single.isCompleted, isTrue);

      // Act (2)
      final secondToggle = provider.toggleTask('1');

      // Assert (2)
      expect(secondToggle, isTrue);
      expect(provider.tasks.single.isCompleted, isFalse);
    });

    test('toggleTask returns false for missing task', () {
      // Act
      final result = provider.toggleTask('missing');

      // Assert
      expect(result, isFalse);
    });

    test('setFilter filters tasks correctly', () {
      // Arrange
      provider
        ..addTask(TaskFixtures.activeTask)
        ..addTask(TaskFixtures.completedTask);

      // Act & Assert
      provider.setFilter(TaskFilter.active);
      expect(provider.tasks.single.id, '1');

      provider.setFilter(TaskFilter.completed);
      expect(provider.tasks.single.id, '2');

      provider.setFilter(TaskFilter.all);
      expect(provider.tasks.length, 2);
    });

    test('public task lists are immutable', () {
      // Arrange
      provider.addTask(TaskFixtures.basicTask);

      // Act & Assert
      expect(
        () => provider.allTasks.add(TaskFixtures.secondTask),
        throwsUnsupportedError,
      );
      expect(() => provider.tasks.clear(), throwsUnsupportedError);
    });

    test('count getters return all, active, and completed totals', () {
      // Arrange
      provider
        ..addTask(TaskFixtures.activeTask)
        ..addTask(TaskFixtures.completedTask);

      // Act & Assert
      expect(provider.totalCount, 2);
      expect(provider.activeCount, 1);
      expect(provider.completedCount, 1);
    });
  });
}
