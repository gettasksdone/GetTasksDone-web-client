import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get _theme => Theme.of(this);
  ColorScheme get colorScheme => _theme.colorScheme;
  Size get parentSize => MediaQuery.sizeOf(this);
}
