import 'package:gtd_client/widgets/text_with_icon.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class ContextCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ContextCard({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: rowPadding,
      child: Tooltip(
        message: 'Editar contexto',
        child: SolidButton(
          leftAligned: true,
          onPressed: onPressed,
          size: cardElementSize,
          color: context.colorScheme.secondary,
          withWidget: Padding(
            padding: cardInnerPadding,
            child: TextWithIcon(
              text: text,
              icon: Icons.push_pin,
            ),
          ),
        ),
      ),
    );
  }
}
