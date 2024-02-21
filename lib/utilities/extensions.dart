import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get parentSize => MediaQuery.sizeOf(this);
  Color get hoverColor => theme.hoverColor;
  ColorScheme get colorScheme => theme.colorScheme;
}

extension ColorExtension on Color {
  Color darken(int percent) {
    assert(0 <= percent && percent <= 100);

    final darkenValue = 1 - percent / 100;

    return Color.fromARGB(
      alpha,
      (red * darkenValue).round(),
      (green * darkenValue).round(),
      (blue * darkenValue).round(),
    );
  }

  Color lighten(int percent) {
    assert(0 <= percent && percent <= 100);

    final lightenValue = percent / 100;

    return Color.fromARGB(
      alpha,
      red + ((255 - red) * lightenValue).round(),
      green + ((255 - green) * lightenValue).round(),
      blue + ((255 - blue) * lightenValue).round(),
    );
  }
}
