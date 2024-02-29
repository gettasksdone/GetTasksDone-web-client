import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final double height;
  final double? width;
  final String? label;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.label,
    this.width,
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
      label: label != null
          ? Text(
              label!,
              style: TextStyle(
                fontSize: defaultFontSize,
                color: colors.onSecondary,
              ),
            )
          : const SizedBox.shrink(),
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        fixedSize: Size(width ?? size.width, height),
        padding: const EdgeInsets.all(paddingAmount),
        backgroundColor: colors.primary.lighten(80).withAlpha(65),
        shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
      ).merge(
        ButtonStyle(overlayColor: MaterialStatePropertyAll(context.hoverColor)),
      ),
    );
  }
}
