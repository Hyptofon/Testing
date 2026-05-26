class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    required String id,
    required String title,
    this.isCompleted = false,
    required this.createdAt,
  }) : id = _validateId(id),
       title = _validateTitle(title);

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: _readRequiredString(json, 'id'),
      title: _readRequiredString(json, 'title'),
      isCompleted: _readBool(json, 'isCompleted'),
      createdAt: _readDateTime(json, 'createdAt'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
  };

  Task copyWith({String? title, bool? isCompleted, DateTime? createdAt}) {
    return Task(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static String _readRequiredString(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is! String) {
      throw FormatException('Expected "$key" to be a string.');
    }

    return key == 'title' ? _validateTitle(value) : _validateId(value);
  }

  static bool _readBool(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value == null) {
      return false;
    }

    if (value is bool) {
      return value;
    }

    throw FormatException('Expected "$key" to be a boolean.');
  }

  static DateTime _readDateTime(Map<String, dynamic> json, String key) {
    final value = json[key];

    if (value is! String) {
      throw FormatException('Expected "$key" to be a date string.');
    }

    return DateTime.parse(value);
  }

  static String _validateId(String value) {
    final sanitized = value.trim();

    if (sanitized.isEmpty) {
      throw ArgumentError.value(value, 'id', 'Task id cannot be empty');
    }

    return sanitized;
  }

  static String _validateTitle(String value) {
    final sanitized = value.trim();

    if (sanitized.isEmpty) {
      throw ArgumentError.value(value, 'title', 'Task title cannot be empty');
    }

    return sanitized;
  }
}
