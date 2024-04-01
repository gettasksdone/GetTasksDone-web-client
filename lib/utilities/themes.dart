import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color.fromRGBO(51, 84, 230, 1);

  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      onPrimary: Colors.white,
      secondary: Colors.grey.darken(55),
      onSecondary: Colors.white,
      tertiary: Colors.grey.darken(45),
      onTertiary: Colors.white,
      onSurface: Colors.white.darken(40),
      errorContainer: Colors.red.darken(30),
      onErrorContainer: Colors.white,
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: Color.fromARGB(255, 38, 41, 48),
      headerForegroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
  );

  const AppTheme._();
}
