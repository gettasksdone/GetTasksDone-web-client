import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? withWidget;
  final double? textSize;
  final Color? textColor;
  final bool leftAligned;
  final Color? color;
  final String? text;
  final Size? size;

  SolidButton({
    super.key,
    required this.onPressed,
    this.withWidget,
    this.textColor,
    this.textSize,
    this.color,
    this.size,
    this.text,
    this.leftAligned = false,
  }) {
    assert((text != null) || (withWidget != null));
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: size,
        disabledBackgroundColor: Colors.grey,
        backgroundColor: color ?? colors.primary,
        alignment: leftAligned ? Alignment.centerLeft : null,
        shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
      ),
      child: withWidget == null
          ? Text(
              text!,
              style: TextStyle(
                fontSize: textSize,
                color: textColor ?? colors.onPrimary,
              ),
            )
          : withWidget!,
    );
  }
}
