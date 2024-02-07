import 'package:blackforesttools/utilities/extensions.dart';
import 'package:flutter/material.dart';

class BlackForestLogo extends StatelessWidget {
  final double size;

  const BlackForestLogo({super.key, this.size = 200.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: context.colorScheme.primary),
      child: const Image(
        image: AssetImage('assets/images/blackforestlogo.png'),
      ),
    );
  }
}
