import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../constants/app_strings.dart';
import '../models/task.dart';
import '../models/task_api_exception.dart';
import '../utils/validators.dart';

class TaskApiService {
  static final Uri tasksUri = Uri.parse(
    '${ApiConstants.baseUrl}${ApiConstants.tasksPath}',
  );

  final http.Client _client;
  final bool _ownsClient;

  TaskApiService({http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await _client
          .get(tasksUri)
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode != 200) {
        throw TaskApiException(
          '${AppStrings.failedToLoadTasks}. Status: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw const TaskApiException(AppStrings.invalidTasksResponse);
      }

      return decoded
          .map((item) {
            if (item is! Map) {
              throw const TaskApiException(AppStrings.invalidTasksResponse);
            }

            return Task.fromJson(_readJsonObject(item));
          })
          .toList(growable: false);
    } on TaskApiException {
      rethrow;
    } on FormatException catch (error) {
      throw TaskApiException(
        '${AppStrings.invalidTasksResponse}: ${error.message}',
      );
    } on TypeError {
      throw const TaskApiException(AppStrings.invalidTasksResponse);
    } on TimeoutException {
      throw const TaskApiException(AppStrings.requestTimedOut);
    } on http.ClientException catch (error) {
      throw TaskApiException(
        '${AppStrings.failedToLoadTasks}: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logDebugError('Unexpected fetchTasks failure', error, stackTrace);

      throw const TaskApiException(AppStrings.unexpectedError);
    }
  }

  Future<Task> createTask({required String title}) async {
    final sanitizedTitle = title.trim();
    final validationError = Validators.validateTitle(sanitizedTitle);

    if (validationError != null) {
      throw TaskApiException(validationError);
    }

    try {
      final response = await _client
          .post(
            tasksUri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'title': sanitizedTitle}),
          )
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode != 201) {
        throw TaskApiException(
          '${AppStrings.failedToCreateTask}. Status: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw const TaskApiException(AppStrings.invalidTasksResponse);
      }

      return Task.fromJson(_readJsonObject(decoded));
    } on TaskApiException {
      rethrow;
    } on FormatException catch (error) {
      throw TaskApiException(
        '${AppStrings.invalidTasksResponse}: ${error.message}',
      );
    } on TypeError {
      throw const TaskApiException(AppStrings.invalidTasksResponse);
    } on TimeoutException {
      throw const TaskApiException(AppStrings.requestTimedOut);
    } on http.ClientException catch (error) {
      throw TaskApiException(
        '${AppStrings.failedToCreateTask}: ${error.message}',
      );
    } catch (error, stackTrace) {
      _logDebugError('Unexpected createTask failure', error, stackTrace);

      throw const TaskApiException(AppStrings.unexpectedError);
    }
  }

  static Map<String, dynamic> _readJsonObject(Map<dynamic, dynamic> value) {
    if (value.keys.every((key) => key is String)) {
      return Map<String, dynamic>.from(value);
    }

    throw const FormatException('Expected object keys to be strings.');
  }

  static void _logDebugError(
    String message,
    Object error,
    StackTrace stackTrace,
  ) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('$message: $error\n$stackTrace');
  }

  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }
}
