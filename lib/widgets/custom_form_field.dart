import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final TextInputType? _keyboardType;
  final bool _gotAutofillHint;
  final String? autofillHint;
  final String? initialValue;
  final String? hintText;
  final bool multiline;
  final String? label;
  final bool expands;

  const CustomFormField({
    super.key,
    this.autofillHint,
    this.initialValue,
    this.validator,
    this.hintText,
    this.label,
    this.multiline = false,
    this.expands = false,
  })  : _keyboardType = multiline ? TextInputType.multiline : null,
        _gotAutofillHint = autofillHint != null;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  static const double _edgeWidth = 3.0;

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
    final ColorScheme colors = context.colorScheme;

    return TextFormField(
      key: _fieldKey,
      focusNode: _focusNode,
      expands: widget.expands,
      validator: widget.validator,
      initialValue: widget.initialValue,
      keyboardType: widget._keyboardType,
      minLines: widget.expands ? null : 1,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(color: colors.onPrimary),
      maxLines: widget.multiline || widget.expands ? null : 1,
      autofillHints: widget._gotAutofillHint ? [widget.autofillHint!] : null,
      obscureText: widget._gotAutofillHint
          ? widget.autofillHint == AutofillHints.password
          : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelStyle: TextStyle(color: colors.onPrimary),
        label: widget.label != null ? Text(widget.label!) : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 17.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: _edgeWidth,
            color: colors.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: _edgeWidth,
            color: colors.primary.darken(20),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: _edgeWidth,
            color: colors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: _edgeWidth,
            color: colors.error.darken(10),
          ),
        ),
      ),
    );
  }
}
