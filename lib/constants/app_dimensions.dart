import 'package:flutter/material.dart';

class AppDimensions {
  const AppDimensions._();

  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  static const double smallIconSize = 16;
  static const double mediumIconSize = 20;
  static const double largeIconSize = 24;
  static const double stateIconSize = 64;

  static const double cardRadius = 8;
  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(cardRadius),
  );

  static const EdgeInsets screenPadding = EdgeInsets.all(spacing16);
  static const EdgeInsets formPadding = EdgeInsets.fromLTRB(
    spacing16,
    spacing16,
    spacing16,
    spacing8,
  );
  static const EdgeInsets listPadding = EdgeInsets.fromLTRB(
    spacing16,
    spacing8,
    spacing16,
    spacing16,
  );
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(
    horizontal: spacing16,
    vertical: spacing8,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(spacing16);
}
