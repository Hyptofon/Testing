import 'task.dart';

sealed class TaskActionResult {
  const TaskActionResult();
}

class TaskActionSuccess extends TaskActionResult {
  final Task task;

  const TaskActionSuccess({required this.task});
}

class TaskActionFailure extends TaskActionResult {
  final String message;

  const TaskActionFailure({required this.message});
}
