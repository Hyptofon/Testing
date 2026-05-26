import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../models/task_action_result.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_form.dart';
import '../widgets/task_filter_chips.dart';
import '../widgets/task_list_widget.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            tooltip: AppStrings.openDetails,
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).pushNamed(DetailsScreen.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AddTaskForm(
              onSubmit: (title) {
                final result = context.read<TaskProvider>().createTask(
                  title: title,
                );

                if (result case TaskActionFailure(:final message)) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                }
              },
            ),
            const TaskFilterChips(),
            const SizedBox(height: AppDimensions.spacing8),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, _) {
                  return TaskListWidget(
                    tasks: provider.tasks,
                    onToggle: provider.toggleTask,
                    onDelete: provider.removeTask,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
