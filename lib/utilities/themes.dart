import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color _transparentGrey = Color.fromARGB(115, 158, 158, 158);
  static const Color _appBlue = Color.fromRGBO(51, 84, 230, 1);

  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _appBlue,
      surface: Colors.transparent,
      onSurface: _transparentGrey,
      primary: _appBlue,
      onPrimary: Colors.white,
      secondary: _transparentGrey,
      onSecondary: Colors.white,
    ),
  );
}
