import 'package:gtd_client/widgets/custom_progress_indicator.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:flutter/material.dart';

class LoadingSolidButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final double? textSize;
  final Color? textColor;
  final Color? color;
  final String text;
  final Size? size;

  const LoadingSolidButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.textSize,
    this.color,
    this.size,
  });

  @override
  State<LoadingSolidButton> createState() => _LoadingSolidButtonState();
}

class _LoadingSolidButtonState extends State<LoadingSolidButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return SolidButton(
      text: widget.text,
      size: widget.size,
      color: widget.color,
      textSize: widget.textSize,
      textColor: widget.textColor,
      withWidget: _pressed
          ? CustomProgressIndicator(color: context.colorScheme.onPrimary)
          : null,
      onPressed: widget.onPressed == null
          ? null
          : () async {
              setState(() {
                _pressed = true;
              });

              await widget.onPressed!();

              setState(() {
                _pressed = false;
              });
            },
    );
  }
}
