import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../providers/task_provider.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.detailsTitle)),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.detailsBody, style: textTheme.bodyLarge),
              const SizedBox(height: AppDimensions.spacing24),
              _StatLine(
                label: AppStrings.allFilter,
                value: provider.totalCount,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              _StatLine(
                label: AppStrings.activeFilter,
                value: provider.activeCount,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              _StatLine(
                label: AppStrings.completedFilter,
                value: provider.completedCount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final int value;

  const _StatLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Text(label, style: textTheme.titleMedium)),
        Text('$value', style: textTheme.titleMedium),
      ],
    );
  }
}
