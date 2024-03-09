import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(51, 84, 230, 1),
      secondary: Colors.grey.darken(55),
      onSecondary: Colors.white,
    ),
  );

  const AppTheme._();
}
