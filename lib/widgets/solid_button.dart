import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? textSize;
  final String text;
  final Size? size;

  const SolidButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textSize,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: size,
        backgroundColor: colors.primary,
        disabledBackgroundColor: Colors.grey,
        shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize,
          color: colors.onPrimary,
        ),
      ),
    );
  }
}
