import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  static const List<int> _percents = [8, 16, 24];

  final VoidCallback? onPressed;
  final bool lightenGradient;
  final String buttonText;
  final double? height;
  final double? width;

  const GradientButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.width,
    this.lightenGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Size parentSize = context.parentSize;

    return Container(
      decoration: BoxDecoration(
        borderRadius: roundedCorners,
        gradient: LinearGradient(
          end: Alignment.topRight,
          begin: Alignment.bottomLeft,
          colors: lightenGradient
              ? [
                  colors.primary.lighten(_percents[0]),
                  colors.primary.lighten(_percents[1]),
                  colors.primary.lighten(_percents[2]),
                ]
              : [
                  colors.primary.darken(_percents[0]),
                  colors.primary.darken(_percents[1]),
                  colors.primary.darken(_percents[2]),
                ],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: colors.primary.lighten(70),
          shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
          fixedSize: Size(
            width ?? parentSize.width,
            height ?? parentSize.height,
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 17.0,
            color: colors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
