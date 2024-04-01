import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const TextWithIcon({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colors.onPrimary,
        ),
        const SizedBox(width: 5.0),
        Text(
          text,
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: cardElementFontSize,
          ),
        ),
      ],
    );
  }
}