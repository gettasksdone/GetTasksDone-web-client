import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class AppTitleText extends StatelessWidget {
  final String text;

  const AppTitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w500,
        color: context.colorScheme.secondary,
      ),
    );
  }
}
