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
    final ColorScheme colors = context.colorScheme;
    final Size parentSize = context.parentSize;

    return TextButton.icon(
      onPressed: onPressed,
      label: Text(
        buttonText,
        style: TextStyle(
          fontSize: defaultFontSize,
          color: colors.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: SvgPicture.asset(
        'assets/svgs/$fileName.svg',
        width: 35.0,
      ),
      style: TextButton.styleFrom(
        backgroundColor: colors.onSurface,
        fixedSize: Size(
          width ?? parentSize.width,
          height ?? parentSize.height,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: roundedCorners,
          side: BorderSide(
            width: edgeWidth,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}
