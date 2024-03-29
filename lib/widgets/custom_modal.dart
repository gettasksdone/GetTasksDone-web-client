import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final List<Widget> bodyWidgets;
  final Widget titleWidget;

  CustomModal({
    super.key,
    required this.titleWidget,
    required this.bodyWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: context.theme.canvasColor,
      shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
      child: SizedBox(
        width: modalSize.width,
        height: modalSize.height,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: modalHeaderHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    borderRadius: const BorderRadius.vertical(
                      top: cornerRadius,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: cardPadding,
                      child: titleWidget,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: cardPadding,
                  child: ListView(children: bodyWidgets),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: cardPaddingAmount,
                  bottom: cardPaddingAmount,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SolidButton(
                    color: Colors.green,
                    size: const Size(200.0, 60.0),
                    withWidget: const Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
