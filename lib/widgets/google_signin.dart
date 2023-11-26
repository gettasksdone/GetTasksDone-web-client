import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.colorScheme.secondary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(context.parentSize.width, 60),
      ),
      child: const Text(
        "Continue with Google",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }
}
