import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomFormTitle extends StatelessWidget {
  final bool primaryColored;
  final String titleText;

  const CustomFormTitle({
    super.key,
    required this.titleText,
    this.primaryColored = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Container(
      height: appFormContainerHeight,
      decoration: BoxDecoration(
        borderRadius: roundedCorners,
        color: primaryColored ? colors.primary : colors.secondary,
      ),
      child: Center(
        child: Text(
          titleText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColored ? colors.onPrimary : colors.onSecondary,
          ),
        ),
      ),
    );
  }
}
