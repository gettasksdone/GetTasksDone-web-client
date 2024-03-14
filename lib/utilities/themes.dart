import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(51, 84, 230, 1),
      onSecondary: Colors.white,
      onBackground: Colors.white,
      tertiary: Colors.grey.darken(45),
      secondary: Colors.grey.darken(55),
      onSurface: Colors.white.darken(40),
    ),
  );

  const AppTheme._();
}
