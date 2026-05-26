class TaskApiException implements Exception {
  final String message;

  const TaskApiException(this.message);

  @override
  String toString() => 'TaskApiException: $message';
}
