import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final double? height;
  final double? width;

  const GradientButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Size parentSize = context.parentSize;

    return Container(
      decoration: BoxDecoration(
        borderRadius: roundedCorners,
        gradient: LinearGradient(
          end: Alignment.centerRight,
          begin: Alignment.centerLeft,
          colors: [colors.primary, Colors.transparent],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: colors.onSurface,
          shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
          fixedSize: Size(
            width ?? parentSize.width,
            height ?? parentSize.height,
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
