import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../utils/validators.dart';

class AddTaskForm extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  const AddTaskForm({super.key, required this.onSubmit});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) {
      return;
    }

    widget.onSubmit(_titleController.text.trim());
    _titleController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.formPadding,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: AppStrings.taskTitleLabel,
                hintText: AppStrings.taskTitleHint,
                prefixIcon: Icon(Icons.task_alt_outlined),
              ),
              textInputAction: TextInputAction.done,
              validator: Validators.validateTitle,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add_task_outlined),
              label: const Text(AppStrings.addTask),
            ),
          ],
        ),
      ),
    );
  }
}
