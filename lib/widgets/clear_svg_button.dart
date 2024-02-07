import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/clear_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ClearSvgButton extends ClearButton {
  final String fileName;

  const ClearSvgButton({
    super.key,
    required super.buttonText,
    required super.onPressed,
    required this.fileName,
    super.height,
    super.width,
  });

  @override
  Widget build(BuildContext context) {
    final parentSize = context.parentSize;

    return TextButton.icon(
      onPressed: onPressed,
      label: Text(
        buttonText,
        style: const TextStyle(fontSize: 17.0),
      ),
      icon: SvgPicture.asset(
        'assets/svgs/$fileName.svg',
        width: 25.0,
      ),
      style: TextButton.styleFrom(
        fixedSize: Size(
          width ?? parentSize.width,
          height ?? parentSize.height,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: roundedCorners,
          side: BorderSide(
            width: edgeWidth,
            color: context.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
