import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String hint;
  final bool obscure;

  const LoginField({
    super.key,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return SizedBox(
      width: context.parentSize.width,
      child: TextFormField(
        obscureText: obscure,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 23,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.secondary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.primary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hint,
        ),
      ),
    );
  }
}
