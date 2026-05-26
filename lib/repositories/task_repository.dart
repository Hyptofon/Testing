import '../models/task.dart';
import '../services/task_api_service.dart';

class TaskRepository {
  List<Task> _cachedTasks = const <Task>[];

  final TaskApiService _apiService;
  final bool _ownsApiService;

  TaskRepository({TaskApiService? apiService})
    : _apiService = apiService ?? TaskApiService(),
      _ownsApiService = apiService == null;

  List<Task> get cachedTasks => List.unmodifiable(_cachedTasks);

  bool get hasCachedTasks => _cachedTasks.isNotEmpty;

  Future<List<Task>> fetchTasks() async {
    final tasks = await _apiService.fetchTasks();
    _cachedTasks = List.unmodifiable(tasks);

    return cachedTasks;
  }

  Future<Task> createTask({required String title}) =>
      _apiService.createTask(title: title);

  void dispose() {
    if (_ownsApiService) {
      _apiService.dispose();
    }
  }
}
