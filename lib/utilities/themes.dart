import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  static final light = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
  );
}