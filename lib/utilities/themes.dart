import 'package:flutter/material.dart';

class AppTheme {
  static const Color _hoverColor = Color.fromARGB(35, 158, 158, 158);
  static const Color _appBlue = Color.fromRGBO(51, 84, 230, 1);

  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    hoverColor: _hoverColor,
    highlightColor: _hoverColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _appBlue,
      surface: Colors.transparent,
      onSurface: const Color.fromARGB(35, 158, 158, 158),
      primary: _appBlue,
      onPrimary: Colors.white,
      secondary: const Color.fromARGB(255, 158, 158, 158),
      onSecondary: Colors.white,
    ),
  );

  const AppTheme._();
}
