import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/clear_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ClearIconButton extends ClearButton {
  final String svgName;

  const ClearIconButton({
    super.key,
    required super.text,
    required super.onPressed,
    required this.svgName,
    super.width,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    final parentSize = context.parentSize;

    return TextButton.icon(
      icon: SvgPicture.asset(
        'assets/svgs/$svgName.svg',
        width: 25,
      ),
      onPressed: onPressed,
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.colorScheme.secondary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(
          width ?? parentSize.width,
          height ?? parentSize.height,
        ),
      ),
    );
  }
}
