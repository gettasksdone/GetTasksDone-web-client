import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  late final List<TextInputFormatter>? _onlyNumeric;
  final String? Function(String?)? validator;
  late final TextInputType? _keyboardType;
  final TextEditingController? controller;
  final bool _gotAutofillHint;
  final String? autofillHint;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? hintText;
  final bool multiline;
  final String? label;
  final bool expands;

  CustomFormField({
    super.key,
    this.autofillHint,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.validator,
    this.hintText,
    this.label,
    this.multiline = false,
    this.expands = false,
    bool numeric = false,
  }) : _gotAutofillHint = autofillHint != null {
    if (numeric) {
      _onlyNumeric = [FilteringTextInputFormatter.digitsOnly];
      _keyboardType = TextInputType.number;

      return;
    }

    _keyboardType = multiline ? TextInputType.multiline : null;
    _onlyNumeric = null;
  }

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey();

  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus & (_fieldKey.currentState != null)) {
        _fieldKey.currentState!.validate();
      }
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode!.dispose();
    }

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
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: widget._keyboardType,
      minLines: widget.expands ? null : 1,
      inputFormatters: widget._onlyNumeric,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(color: colors.onSecondary),
      maxLines: widget.multiline || widget.expands ? null : 1,
      autofillHints: widget._gotAutofillHint ? [widget.autofillHint!] : null,
      obscureText: widget._gotAutofillHint
          ? widget.autofillHint == AutofillHints.password
          : false,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        hintText: widget.hintText,
        labelStyle: TextStyle(color: colors.onSecondary),
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
