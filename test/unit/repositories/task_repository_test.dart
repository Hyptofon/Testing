import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/models/task.dart';
import 'package:lr14_testing/repositories/task_repository.dart';
import 'package:lr14_testing/services/task_api_service.dart';

import '../../fixtures/task_fixtures.dart';

void main() {
  group('TaskRepository', () {
    test('fetchTasks caches tasks scoped to repository instance', () async {
      // Arrange
      final firstRepository = TaskRepository(
        apiService: _FakeTaskApiService(
          tasks: [TaskFixtures.basicTask],
        ),
      );
      final secondRepository = TaskRepository(
        apiService: _FakeTaskApiService(
          tasks: [TaskFixtures.secondTask],
        ),
      );

      // Act
      await firstRepository.fetchTasks();

      // Assert
      expect(firstRepository.hasCachedTasks, isTrue);
      expect(secondRepository.hasCachedTasks, isFalse);

      // Act (2)
      await secondRepository.fetchTasks();

      // Assert (2)
      expect(firstRepository.cachedTasks.single.title, 'Task 1');
      expect(secondRepository.cachedTasks.single.title, 'Task 2');
    });

    test('cachedTasks getter returns immutable list', () async {
      // Arrange
      final repository = TaskRepository(
        apiService: _FakeTaskApiService(
          tasks: [TaskFixtures.basicTask],
        ),
      );
      await repository.fetchTasks();

      // Act & Assert
      expect(
        () => repository.cachedTasks.add(TaskFixtures.secondTask),
        throwsUnsupportedError,
      );
    });

    test('createTask delegates title to api service', () async {
      // Arrange
      final apiService = _FakeTaskApiService(tasks: const []);
      final repository = TaskRepository(apiService: apiService);

      // Act
      final task = await repository.createTask(title: 'New Task');

      // Assert
      expect(apiService.createdTitle, 'New Task');
      expect(task.title, 'New Task');
    });
  });
}

class _FakeTaskApiService extends TaskApiService {
  final List<Task> tasks;
  String? createdTitle;

  _FakeTaskApiService({required this.tasks});

  @override
  Future<List<Task>> fetchTasks() async => tasks;

  @override
  Future<Task> createTask({required String title}) async {
    createdTitle = title;
    return Task(
      id: 'created',
      title: title,
      createdAt: TaskFixtures.basicTask.createdAt,
    );
  }

  @override
  void dispose() {}
}
