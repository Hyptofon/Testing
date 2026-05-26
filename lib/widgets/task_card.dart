import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: AppDimensions.cardBorderRadius,
        onTap: onToggle,
        child: Padding(
          padding: AppDimensions.cardPadding,
          child: Row(
            children: [
              Tooltip(
                message: AppStrings.toggleTaskTooltip,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => onToggle(),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Text(
                  task.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: task.isCompleted ? colorScheme.outline : null,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing8),
              IconButton(
                tooltip: AppStrings.deleteTaskTooltip,
                icon: const Icon(Icons.delete_outline),
                color: colorScheme.error,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
