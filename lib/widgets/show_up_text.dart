import 'package:flutter/material.dart';

class ShowUpText extends StatelessWidget {
  final TextStyle? textStyle;
  final bool visible;
  final String? text;

  const ShowUpText(
      {super.key, required this.text, required this.visible, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: visible
          ? Text(
              text ?? '',
              style: textStyle,
            )
          : const SizedBox.shrink(),
    );
  }
}
