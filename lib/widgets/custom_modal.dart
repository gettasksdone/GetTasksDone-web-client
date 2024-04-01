import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final Widget titleWidget;
  final Widget bodyWidget;

  CustomModal({
    super.key,
    required this.titleWidget,
    required this.bodyWidget,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: context.theme.canvasColor,
      shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
      child: SizedBox(
        width: 1200.0,
        height: 700.0,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 110.0,
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
