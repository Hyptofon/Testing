import 'package:lr14_testing/models/task.dart';

class TaskFixtures {
  static Task get basicTask => Task(
        id: '1',
        title: 'Task 1',
        createdAt: DateTime(2026, 2, 13),
      );

  static Task get secondTask => Task(
        id: '2',
        title: 'Task 2',
        createdAt: DateTime(2026, 2, 13),
      );

  static Task get completedTask => Task(
        id: '2', // Often used alongside basicTask in lists
        title: 'Completed Task',
        isCompleted: true,
        createdAt: DateTime(2026, 2, 13),
      );

  static Task get activeTask => Task(
        id: '1',
        title: 'Active Task',
        createdAt: DateTime(2026, 2, 13),
      );

  static List<Task> get mixedTasks => [activeTask, completedTask];
}
