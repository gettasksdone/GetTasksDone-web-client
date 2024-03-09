import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(51, 84, 230, 1),
    ),
  );

  const AppTheme._();
}
