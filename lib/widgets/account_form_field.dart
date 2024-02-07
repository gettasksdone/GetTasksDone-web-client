import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter/material.dart';

class AccountFormField extends StatefulWidget {
  final String? Function(String?)? validator;
  final bool _gotAutofillHint;
  final String? autofillHint;
  final String? hintText;

  const AccountFormField({
    super.key,
    required this.hintText,
    this.autofillHint,
    this.validator,
  }) : _gotAutofillHint = autofillHint != null;

  @override
  State<AccountFormField> createState() => _AccountFormFieldState();
}

class _AccountFormFieldState extends State<AccountFormField> {
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
      validator: widget.validator,
      autofillHints: widget._gotAutofillHint ? [widget.autofillHint!] : null,
      obscureText: widget._gotAutofillHint
          ? widget.autofillHint == AutofillHints.password
          : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 23.0,
          horizontal: 20.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: colors.primary.lighten(45),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: colors.primary,
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
