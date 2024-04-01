import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: colors.errorContainer,
      ),
      icon: Icon(
        Icons.delete,
        color: colors.onErrorContainer,
      ),
      onPressed: onPressed,
    );
  }
}
