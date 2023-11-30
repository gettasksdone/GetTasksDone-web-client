import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final Iterable<String> autofillHint;
  final String hint;

  const LoginField({
    super.key,
    required this.hint,
    required this.autofillHint,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return SizedBox(
      width: context.parentSize.width,
      child: TextFormField(
        obscureText: autofillHint.contains(AutofillHints.password),
        autofillHints: autofillHint,
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
