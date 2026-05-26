import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/models/task.dart';
import 'package:lr14_testing/providers/task_provider.dart';

void main() {
  group('Performance Tests (Variant C)', () {
    test('adding 1000 tasks and filtering performance', () {
      // Arrange
      final provider = TaskProvider();
      final stopwatch = Stopwatch();
      const taskCount = 1000;

      // Act: Add 1000 tasks
      stopwatch.start();
      for (int i = 0; i < taskCount; i++) {
        provider.addTask(
          Task(
            id: 'task_$i',
            title: 'Performance Task $i',
            isCompleted: i % 2 == 0, // Half completed
            createdAt: DateTime.now(),
          ),
        );
      }
      final addDuration = stopwatch.elapsedMilliseconds;

      // Act: Filter tasks
      stopwatch.reset();
      provider.setFilter(TaskFilter.active);
      final activeTasks = provider.tasks;
      final filterDuration = stopwatch.elapsedMilliseconds;
      stopwatch.stop();

      // Assert
      expect(provider.totalCount, taskCount);
      expect(activeTasks.length, taskCount ~/ 2);

      // We expect adding 1000 tasks to be relatively fast (e.g., under 100ms)
      expect(addDuration, lessThan(100), reason: 'Adding tasks took too long');
      // We expect filtering 1000 tasks to be very fast (e.g., under 50ms)
      expect(
        filterDuration,
        lessThan(50),
        reason: 'Filtering tasks took too long',
      );
    });
  });
}
