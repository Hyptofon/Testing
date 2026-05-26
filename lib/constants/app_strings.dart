class AppStrings {
  const AppStrings._();

  static const appTitle = 'Todo Testing';
  static const homeTitle = 'Todo List';
  static const detailsTitle = 'Testing Details';

  static const taskTitleLabel = 'Task title';
  static const taskTitleHint = 'Enter task title';
  static const addTask = 'Add Task';
  static const deleteTaskTooltip = 'Delete task';
  static const toggleTaskTooltip = 'Toggle task';

  static const allFilter = 'All';
  static const activeFilter = 'Active';
  static const completedFilter = 'Completed';

  static const emptyTasksTitle = 'No tasks yet';
  static const emptyTasksSubtitle = 'Create your first task to start testing.';
  static const detailsBody =
      'This screen is used by widget tests to verify navigation.';
  static const openDetails = 'Open details';

  static const titleEmptyError = 'Title cannot be empty';
  static const titleShortError = 'Title must be at least 3 characters';
  static const emailEmptyError = 'Email cannot be empty';
  static const emailInvalidError = 'Invalid email format';

  static const failedToLoadTasks = 'Failed to load tasks';
  static const failedToCreateTask = 'Failed to create task';
  static const invalidTasksResponse = 'Invalid tasks response';
  static const requestTimedOut = 'Request timed out. Please try again.';
  static const unexpectedError = 'Something went wrong. Please try again.';
}
