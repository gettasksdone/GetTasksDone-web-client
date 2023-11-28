import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final String text;

  const ClearButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final parentSize = context.parentSize;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.colorScheme.secondary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(
          width ?? parentSize.width,
          height ?? parentSize.height,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
