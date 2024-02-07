import 'package:blackforesttools/widgets/custom_text_form_field.dart';
import 'package:blackforesttools/widgets/gradient_button.dart';
import 'package:blackforesttools/widgets/text_checkbox.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/widgets/show_up_text.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter/material.dart';

class AppRequiredFields extends StatefulWidget {
  final String? Function(String?)? taskNameValidator;
  final String? Function(String?) itemsValidator;
  final void Function(bool) onCheckboxChange;
  final VoidCallback onButtonPressed;
  final Widget? belowTextBoxWidget;
  final String? showUpText;
  final String? itemsHint;
  final bool enableButton;
  final bool showUpError;

  const AppRequiredFields({
    super.key,
    required this.onCheckboxChange,
    required this.onButtonPressed,
    required this.itemsValidator,
    required this.enableButton,
    required this.showUpError,
    this.belowTextBoxWidget,
    this.taskNameValidator,
    this.showUpText,
    this.itemsHint,
  });

  @override
  State<AppRequiredFields> createState() => _AppRequiredFieldsState();
}

class _AppRequiredFieldsState extends State<AppRequiredFields> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Decoration containerDecoration = BoxDecoration(
      color: colors.secondary,
      borderRadius: roundedCorners,
    );

    return Column(
      children: [
        Padding(
          padding: rowPadding,
          child: CustomTextFormField(
            multiline: true,
            hintText: widget.itemsHint,
            validator: widget.itemsValidator,
          ),
        ),
        if (widget.belowTextBoxWidget != null)
          Padding(
            padding: rowPadding,
            child: widget.belowTextBoxWidget!,
          ),
        Padding(
          padding: rowPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextFormField(
                  hintText: 'task name',
                  validator: widget.taskNameValidator,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  decoration: containerDecoration,
                  child: TextCheckbox(
                    onChanged: widget.onCheckboxChange,
                    text: 'Notify me when task is done',
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: rowPadding,
          child: Container(
            height: appFormContainerHeight,
            decoration: containerDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10.0,
                    top: halfPaddingAmount,
                    left: halfPaddingAmount,
                    bottom: halfPaddingAmount,
                  ),
                  child: GradientButton(
                    width: 150.0,
                    lightenGradient: true,
                    buttonText: 'S E N D',
                    onPressed:
                        widget.enableButton ? widget.onButtonPressed : null,
                  ),
                ),
                ShowUpText(
                  text: widget.showUpText,
                  visible: widget.showUpText != null,
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color:
                        widget.showUpError ? colors.error : colors.onSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
