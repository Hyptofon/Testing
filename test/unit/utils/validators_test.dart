import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/utils/validators.dart';
import 'package:test/test.dart';

void main() {
  group('Validators', () {
    group('validateTitle', () {
      test('returns null for valid title', () {
        // Arrange & Act
        final result = Validators.validateTitle('Valid Task');
        // Assert
        expect(result, isNull);
      });

      test('returns error for empty title', () {
        // Arrange & Act
        final result = Validators.validateTitle('');
        // Assert
        expect(result, AppStrings.titleEmptyError);
      });

      test('returns error for whitespace title', () {
        // Arrange & Act
        final result = Validators.validateTitle('   ');
        // Assert
        expect(result, AppStrings.titleEmptyError);
      });

      test('returns error for null title', () {
        // Arrange & Act
        final result = Validators.validateTitle(null);
        // Assert
        expect(result, AppStrings.titleEmptyError);
      });

      test('returns error for short title', () {
        // Arrange & Act
        final result = Validators.validateTitle('Ab');
        // Assert
        expect(result, AppStrings.titleShortError);
      });
    });

    group('validateEmail', () {
      test('returns null for valid email', () {
        // Arrange & Act
        final result = Validators.validateEmail('test@example.com');
        // Assert
        expect(result, isNull);
      });

      test('returns error for invalid email', () {
        // Arrange & Act
        final result = Validators.validateEmail('invalid-email');
        // Assert
        expect(result, AppStrings.emailInvalidError);
      });

      test('returns error for empty email', () {
        // Arrange & Act
        final result = Validators.validateEmail('');
        // Assert
        expect(result, AppStrings.emailEmptyError);
      });
    });

    group('isTaskOverdue', () {
      test('returns true for past date', () {
        // Arrange
        final now = DateTime(2026, 2, 13, 12);
        final pastDate = DateTime(2026, 2, 12, 12);

        // Act
        final result = Validators.isTaskOverdue(pastDate, now: now);

        // Assert
        expect(result, isTrue);
      });

      test('returns false for future date', () {
        // Arrange
        final now = DateTime(2026, 2, 13, 12);
        final futureDate = DateTime(2026, 2, 14, 12);

        // Act
        final result = Validators.isTaskOverdue(futureDate, now: now);

        // Assert
        expect(result, isFalse);
      });
    });

    test('compose returns first validation error', () {
      // Arrange
      final validator = Validators.compose([
        Validators.validateTitle,
        (_) => 'Second error',
      ]);

      // Act
      final result = validator('');

      // Assert
      expect(result, AppStrings.titleEmptyError);
    });
  });
}
