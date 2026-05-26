import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_dimensions.dart';
import '../providers/task_provider.dart';

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TaskFilter.values
            .map((filter) {
              final isSelected = provider.filter == filter;

              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spacing8),
                child: ChoiceChip(
                  label: Text(provider.getFilterLabel(filter)),
                  selected: isSelected,
                  onSelected: (_) =>
                      context.read<TaskProvider>().setFilter(filter),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
