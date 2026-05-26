import 'package:flutter_test/flutter_test.dart';
import 'package:lr14_testing/constants/app_strings.dart';
import 'package:lr14_testing/main.dart';

void main() {
  testWidgets('MyApp shows Todo home screen', (tester) async {
    // Arrange & Act
    await tester.pumpWidget(const MyApp());

    // Assert
    expect(find.text(AppStrings.homeTitle), findsOneWidget);
    expect(find.text(AppStrings.emptyTasksTitle), findsOneWidget);
  });
}
