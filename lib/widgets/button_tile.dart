import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class ButtonTile extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String text;

  const ButtonTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return ListTile(
      onTap: onTap,
      minLeadingWidth: 45.0,
      iconColor: colors.primary,
      title: Text(text),
      leading: Icon(
        icon,
        size: 35.0,
      ),
      titleTextStyle: TextStyle(
        fontSize: 23.0,
        color: colors.onBackground,
      ),
    );
  }
}
