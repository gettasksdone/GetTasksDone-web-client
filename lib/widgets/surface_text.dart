import 'package:gtdclient/utils/utils.dart';
import 'package:flutter/material.dart';

class SurfaceText extends StatelessWidget {
  const SurfaceText(
      {super.key, required this.text, this.fontSize, this.fontWeight});

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: context.textTheme.headlineSmall?.copyWith(
          color: context.colorScheme.surface,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: fontSize,
        ));
  }
}
