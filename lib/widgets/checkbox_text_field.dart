import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class CheckboxTextField extends StatefulWidget {
  final void Function(bool) onChanged;
  final String text;

  const CheckboxTextField({
    super.key,
    required this.onChanged,
    required this.text,
  });

  @override
  State<CheckboxTextField> createState() => _CheckboxTextFieldState();
}

class _CheckboxTextFieldState extends State<CheckboxTextField> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return CheckboxListTile(
      value: _checked,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        widget.text,
        style: TextStyle(color: colors.onSecondary),
      ),
      onChanged: (value) {
        setState(() {
          _checked = !_checked;
        });

        widget.onChanged(_checked);
      },
    );
  }
}
