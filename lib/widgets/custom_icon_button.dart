import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final double height;
  final String label;

  const CustomIconButton({
    super.key,
    required this.label,
    required this.icon,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Size size = context.parentSize;

    return TextButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        size: 30.0,
        color: colors.onSecondary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 18.0,
          color: colors.onSecondary,
        ),
      ),
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        foregroundColor: colors.onSecondary,
        fixedSize: Size(size.width, height),
        padding: const EdgeInsets.all(paddingAmount),
        backgroundColor: colors.onSurface.lighten(80),
        shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
      ),
    );
  }
}
