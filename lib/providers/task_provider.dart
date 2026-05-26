import 'package:flutter/foundation.dart';

import '../constants/app_strings.dart';
import '../models/task.dart';
import '../models/task_action_result.dart';
import '../utils/validators.dart';

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks;
  TaskFilter _filter;

  TaskProvider({
    List<Task> initialTasks = const <Task>[],
    TaskFilter initialFilter = TaskFilter.all,
  }) : _tasks = List<Task>.of(initialTasks),
       _filter = initialFilter;

  List<Task> get allTasks => List.unmodifiable(_tasks);

  List<Task> get tasks => _getFilteredTasks();

  TaskFilter get filter => _filter;

  int get totalCount => _tasks.length;

  int get activeCount => _tasks.where((task) => !task.isCompleted).length;

  int get completedCount => _tasks.where((task) => task.isCompleted).length;

  TaskActionResult createTask({required String title}) {
    final validationError = Validators.validateTitle(title);

    if (validationError != null) {
      return TaskActionFailure(message: validationError);
    }

    final now = DateTime.now();
    final task = Task(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: now,
    );

    addTask(task);
    return TaskActionSuccess(task: task);
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  bool removeTask(String id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    final didRemove = _tasks.length != initialLength;

    if (didRemove) {
      notifyListeners();
    }

    return didRemove;
  }

  bool toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return false;
    }

    final task = _tasks[index];
    _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    notifyListeners();

    return true;
  }

  void setFilter(TaskFilter filter) {
    if (_filter == filter) {
      return;
    }

    _filter = filter;
    notifyListeners();
  }

  String getFilterLabel(TaskFilter filter) {
    return switch (filter) {
      TaskFilter.all => AppStrings.allFilter,
      TaskFilter.active => AppStrings.activeFilter,
      TaskFilter.completed => AppStrings.completedFilter,
    };
  }

  List<Task> _getFilteredTasks() {
    final filteredTasks = switch (_filter) {
      TaskFilter.all => _tasks,
      TaskFilter.active =>
        _tasks.where((task) => !task.isCompleted).toList(growable: false),
      TaskFilter.completed =>
        _tasks.where((task) => task.isCompleted).toList(growable: false),
    };

    return List.unmodifiable(filteredTasks);
  }
}
