import '../constants/app_strings.dart';

class Validators {
  const Validators._();

  static String? validateTitle(String? value) {
    final sanitized = value?.trim();

    if (sanitized == null || sanitized.isEmpty) {
      return AppStrings.titleEmptyError;
    }

    if (sanitized.length < 3) {
      return AppStrings.titleShortError;
    }

    return null;
  }

  static String? validateEmail(String? value) {
    final sanitized = value?.trim();

    if (sanitized == null || sanitized.isEmpty) {
      return AppStrings.emailEmptyError;
    }

    final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(sanitized)) {
      return AppStrings.emailInvalidError;
    }

    return null;
  }

  static bool isTaskOverdue(DateTime dueDate, {DateTime? now}) {
    return dueDate.isBefore(now ?? DateTime.now());
  }

  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);

        if (error != null) {
          return error;
        }
      }

      return null;
    };
  }
}
