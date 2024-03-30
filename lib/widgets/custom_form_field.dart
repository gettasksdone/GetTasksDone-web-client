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

  const CustomFormField({
    super.key,
    required this.hintText,
    this.autofillHint,
    this.initialValue,
    this.validator,
    this.label,
    this.multiline = false,
  })  : _keyboardType = multiline ? TextInputType.multiline : null,
        _gotAutofillHint = autofillHint != null;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
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
      expands: widget.multiline,
      validator: widget.validator,
      initialValue: widget.initialValue,
      keyboardType: widget._keyboardType,
      minLines: widget.multiline ? null : 1,
      maxLines: widget.multiline ? null : 1,
      textAlignVertical: TextAlignVertical.top,
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
            width: edgeWidth,
            color: colors.primary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: colors.primary.darken(20),
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
