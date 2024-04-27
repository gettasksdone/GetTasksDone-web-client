import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CustomModal extends StatelessWidget {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final Widget titleWidget;
  final Widget bodyWidget;
  final Size? size;

  CustomModal({
    super.key,
    required this.titleWidget,
    required this.bodyWidget,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Dialog(
      shape: roundedBorder,
      insetPadding: padding,
      surfaceTintColor: Colors.transparent,
      backgroundColor: context.theme.canvasColor,
      child: SizedBox(
        width: size?.width ?? 1200.0,
        height: max(size?.height ?? 700.0, 200.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    borderRadius: const BorderRadius.vertical(
                      top: cornerRadius,
                    ),
                  ),
                  child: Padding(
                    padding: cardPadding,
                    child: titleWidget,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: cardPadding,
                  child: bodyWidget,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
