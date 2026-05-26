import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/models/task_api_exception.dart';
import 'package:lr14_testing/services/task_api_service.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('TaskApiService', () {
    late MockHttpClient mockClient;
    late TaskApiService service;

    setUp(() {
      mockClient = MockHttpClient();
      service = TaskApiService(client: mockClient);
    });

    tearDown(() {
      service.dispose();
    });

    test('fetchTasks returns list of tasks on success', () async {
      // Arrange
      final responseBody = jsonEncode([
        {
          'id': '1',
          'title': 'Task 1',
          'isCompleted': false,
          'createdAt': '2026-02-13T10:00:00.000',
        },
      ]);

      when(
        mockClient.get(TaskApiService.tasksUri),
      ).thenAnswer((_) async => http.Response(responseBody, 200));

      // Act
      final tasks = await service.fetchTasks();

      // Assert
      expect(tasks.length, 1);
      expect(tasks.single.id, '1');
      expect(tasks.single.title, 'Task 1');
      verify(mockClient.get(TaskApiService.tasksUri)).called(1);
    });

    test('fetchTasks throws TaskApiException on non-200 status', () async {
      // Arrange
      when(
        mockClient.get(TaskApiService.tasksUri),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      await expectLater(
        service.fetchTasks(),
        throwsA(
          isA<TaskApiException>().having(
            (error) => error.message,
            'message',
            contains(AppStrings.failedToLoadTasks),
          ),
        ),
      );
    });

    test('fetchTasks maps invalid payload to TaskApiException', () async {
      // Arrange
      when(
        mockClient.get(TaskApiService.tasksUri),
      ).thenAnswer((_) async => http.Response('{"broken": true}', 200));

      // Act & Assert
      await expectLater(
        service.fetchTasks(),
        throwsA(
          isA<TaskApiException>().having(
            (error) => error.message,
            'message',
            contains(AppStrings.invalidTasksResponse),
          ),
        ),
      );
    });

    test('createTask returns created task on success', () async {
      // Arrange
      final responseBody = jsonEncode({
        'id': '2',
        'title': 'New Task',
        'isCompleted': false,
        'createdAt': '2026-02-13T10:00:00.000',
      });

      when(
        mockClient.post(
          TaskApiService.tasksUri,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(responseBody, 201));

      // Act
      final task = await service.createTask(title: ' New Task ');

      // Assert
      expect(task.id, '2');
      expect(task.title, 'New Task');
    });

    test('createTask sends trimmed title in request body', () async {
      // Arrange
      final responseBody = jsonEncode({
        'id': '3',
        'title': 'Trimmed Task',
        'isCompleted': false,
        'createdAt': '2026-02-13T10:00:00.000',
      });

      when(
        mockClient.post(
          TaskApiService.tasksUri,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(responseBody, 201));

      // Act
      await service.createTask(title: ' Trimmed Task ');

      // Assert
      final verification = verify(
        mockClient.post(
          TaskApiService.tasksUri,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        ),
      )..called(1);
      final requestBody = verification.captured.single as String;

      expect(jsonDecode(requestBody), {'title': 'Trimmed Task'});
    });

    test('createTask throws TaskApiException on server error', () async {
      // Arrange
      when(
        mockClient.post(
          TaskApiService.tasksUri,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Server Error', 500));

      // Act & Assert
      await expectLater(
        service.createTask(title: 'New Task'),
        throwsA(
          isA<TaskApiException>().having(
            (error) => error.message,
            'message',
            contains(AppStrings.failedToCreateTask),
          ),
        ),
      );
    });

    test('createTask validates title before sending request', () async {
      // Act & Assert
      await expectLater(
        service.createTask(title: ''),
        throwsA(
          isA<TaskApiException>().having(
            (error) => error.message,
            'message',
            AppStrings.titleEmptyError,
          ),
        ),
      );

      verifyNever(
        mockClient.post(
          TaskApiService.tasksUri,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      );
    });
  });
}

class MockHttpClient extends Mock implements http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return super.noSuchMethod(
          Invocation.method(#get, [url], {#headers: headers}),
          returnValue: Future<http.Response>.value(http.Response('', 500)),
        )
        as Future<http.Response>;
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return super.noSuchMethod(
          Invocation.method(
            #post,
            [url],
            {#headers: headers, #body: body, #encoding: encoding},
          ),
          returnValue: Future<http.Response>.value(http.Response('', 500)),
        )
        as Future<http.Response>;
  }

  @override
  void close() {
    super.noSuchMethod(Invocation.method(#close, const []));
  }
}
