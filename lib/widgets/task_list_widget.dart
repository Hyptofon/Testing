import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../models/task.dart';
import 'empty_state_widget.dart';
import 'task_card.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const EmptyStateWidget();
    }

    return ListView.builder(
      padding: AppDimensions.listPadding,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskCard(
          task: task,
          onToggle: () => onToggle(task.id),
          onDelete: () => onDelete(task.id),
        );
      },
    );
  }
}
