import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static final light = ThemeData.light(useMaterial3: true).copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      surface: Colors.white,
      onSurface: Colors.grey[900],
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.grey[300],
      onSecondary: Colors.grey[900],
      tertiary: Colors.grey[400],
      onTertiary: Colors.grey[900],
    ),
  );
}
