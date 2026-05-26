import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/models/task.dart';

void main() {
  group('Task Model', () {
    test('creates task with required fields and default completed state', () {
      // Arrange & Act
      final task = Task(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime(2026, 2, 13),
      );

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.isCompleted, isFalse);
      expect(task.createdAt, DateTime(2026, 2, 13));
    });

    test('trims id and title values in constructor', () {
      // Arrange & Act
      final task = Task(
        id: ' 1 ',
        title: ' Test Task ',
        createdAt: DateTime(2026, 2, 13),
      );

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
    });

    test('throws ArgumentError when title is empty', () {
      // Arrange, Act & Assert
      expect(
        () => Task(id: '1', title: ' ', createdAt: DateTime(2026, 2, 13)),
        throwsArgumentError,
      );
    });

    test('fromJson creates task from valid map', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Task',
        'isCompleted': true,
        'createdAt': '2026-02-13T10:00:00.000',
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.isCompleted, isTrue);
      expect(task.createdAt, DateTime(2026, 2, 13, 10));
    });

    test('fromJson uses false when isCompleted is missing', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Task',
        'createdAt': '2026-02-13T10:00:00.000',
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.isCompleted, isFalse);
    });

    test('fromJson fails fast for invalid required field', () {
      // Arrange
      final json = {
        'id': '1',
        'isCompleted': false,
        'createdAt': '2026-02-13T10:00:00.000',
      };

      // Act & Assert
      expect(() => Task.fromJson(json), throwsFormatException);
    });

    test('toJson converts task to map', () {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        isCompleted: true,
        createdAt: DateTime(2026, 2, 13, 10),
      );

      // Act
      final json = task.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['isCompleted'], isTrue);
      expect(json['createdAt'], '2026-02-13T10:00:00.000');
    });

    test('copyWith creates new task with updated fields', () {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Original Task',
        createdAt: DateTime(2026, 2, 13),
      );

      // Act
      final updated = task.copyWith(title: 'Updated Task', isCompleted: true);

      // Assert
      expect(updated.id, task.id);
      expect(updated.title, 'Updated Task');
      expect(updated.isCompleted, isTrue);
      expect(updated.createdAt, task.createdAt);
      expect(task.isCompleted, isFalse);
    });
  });
}
