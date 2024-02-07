import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final double? height;
  final double? width;

  const ClearButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final Size parentSize = context.parentSize;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        fixedSize: Size(
          width ?? parentSize.width,
          height ?? parentSize.height,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: roundedCorners,
          side: BorderSide(
            width: edgeWidth,
            color: context.colorScheme.secondary,
          ),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 17.0),
      ),
    );
  }
}
