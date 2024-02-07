import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  static const double _contentPaddingAmount = 15.0;

  late final List<TextInputFormatter>? _onlyNumeric;
  final String? Function(String?)? validator;
  late final TextInputType? _keyboardType;
  final double verticalPaddingAmount;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final bool showBorder;
  final bool multiline;
  final bool _hasLabel;
  final bool numeric;

  CustomTextFormField({
    super.key,
    this.initialValue,
    this.validator,
    this.labelText,
    this.hintText,
    this.verticalPaddingAmount = _contentPaddingAmount,
    this.showBorder = false,
    this.multiline = false,
    this.numeric = false,
  }) : _hasLabel = labelText != null {
    if (numeric) {
      _keyboardType = TextInputType.number;
      _onlyNumeric = [FilteringTextInputFormatter.digitsOnly];
      return;
    }

    _onlyNumeric = null;

    if (multiline) {
      _keyboardType = TextInputType.multiline;
      return;
    }

    _keyboardType = null;
  }

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey();

  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus & (_fieldKey.currentState != null)) {
        _fieldKey.currentState!.validate();
      }
    });
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = context.darkerSecondary;
    final ColorScheme colors = context.colorScheme;

    return TextFormField(
      key: _fieldKey,
      focusNode: _focusNode,
      validator: widget.validator,
      cursorColor: colors.onSecondary,
      initialValue: widget.initialValue,
      keyboardType: widget._keyboardType,
      minLines: widget.multiline ? 13 : 1,
      inputFormatters: widget._onlyNumeric,
      maxLines: widget.multiline ? null : 1,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(color: colors.onSecondary),
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        fillColor: colors.secondary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: CustomTextFormField._contentPaddingAmount,
          vertical: widget.verticalPaddingAmount,
        ),
        hintStyle: TextStyle(color: secondaryColor),
        floatingLabelBehavior:
            widget._hasLabel ? FloatingLabelBehavior.always : null,
        floatingLabelAlignment:
            widget._hasLabel ? FloatingLabelAlignment.center : null,
        labelStyle: widget._hasLabel
            ? TextStyle(
                color: secondaryColor,
                fontSize: labelFontSize,
                fontWeight: FontWeight.bold,
              )
            : null,
        errorStyle: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
          color: colors.error.darken(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: widget.showBorder ? secondaryColor : Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: secondaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: colors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: colors.error.darken(10),
          ),
        ),
      ),
    );
  }
}
