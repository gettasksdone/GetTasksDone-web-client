import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;

  const CustomProgressIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      color: color ?? context.colorScheme.primary,
    );
  }
}
