import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color.fromRGBO(51, 84, 230, 1);
  static final Color _offWhite = Colors.white.darken(70);

  static final light = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      onPrimary: Colors.white,
      secondary: Colors.white.darken(10),
      onSecondary: _offWhite,
      tertiary: Colors.white.darken(20),
      onTertiary: _offWhite,
      onSurface: _offWhite,
      errorContainer: Colors.red.darken(30),
      onErrorContainer: Colors.white,
    ),
    datePickerTheme: DatePickerThemeData(
      headerForegroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white.darken(30),
    ),
  );

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
      headerForegroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Color.fromARGB(255, 38, 41, 48),
    ),
  );

  const AppTheme._();
}
