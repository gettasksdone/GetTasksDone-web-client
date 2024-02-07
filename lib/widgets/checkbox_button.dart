import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class CheckboxButton extends StatefulWidget {
  final void Function(bool) onChanged;
  final String text;

  const CheckboxButton({
    super.key,
    required this.onChanged,
    required this.text,
  });

  @override
  State<CheckboxButton> createState() => _CheckboxButtonState();
}

class _CheckboxButtonState extends State<CheckboxButton> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return CheckboxListTile(
      value: _checked,
      checkboxShape: const CircleBorder(),
      tileColor: colors.onSurface.lighten(80),
      contentPadding: const EdgeInsets.all(5.0),
      controlAffinity: ListTileControlAffinity.leading,
      shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
      side: BorderSide(
        width: 2.0,
        color: colors.onSecondary,
      ),
      title: Text(
        widget.text,
        style: TextStyle(
          fontSize: 18.0,
          color: colors.onSecondary,
        ),
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
