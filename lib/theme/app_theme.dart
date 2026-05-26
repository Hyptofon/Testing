import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

class AppTheme {
  AppTheme._();

  static const Color _seedColor = Colors.teal;

  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      cardTheme: const CardThemeData(
        elevation: 1,
        margin: AppDimensions.cardMargin,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.cardBorderRadius,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacing8,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing20,
            vertical: AppDimensions.spacing12,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.cardBorderRadius,
          ),
        ),
      ),
    );
  }
}
