import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:flutter/material.dart';

class SolidIconButton extends StatelessWidget {
  final EdgeInsets? innerPadding;
  final VoidCallback? onPressed;
  final double? innerSize;
  final Color? innerColor;
  final IconData icon;
  final Color? color;
  final String text;
  final Size? size;

  const SolidIconButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.innerPadding,
    this.innerColor,
    this.innerSize,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Color finalInnerColor = innerColor ?? colors.onPrimary;

    return SolidButton(
      size: size,
      color: color,
      onPressed: onPressed,
      withWidget: Padding(
        padding: innerPadding ?? const EdgeInsets.all(0.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: finalInnerColor,
              size: innerSize != null ? innerSize! * 1.5 : null,
            ),
            const SizedBox(width: 15.0),
            Text(
              text,
              style: TextStyle(
                fontSize: innerSize,
                color: finalInnerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}