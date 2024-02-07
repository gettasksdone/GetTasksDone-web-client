import 'package:blackforesttools/utilities/extensions.dart';
import 'package:flutter/material.dart';

class TextCheckbox extends StatefulWidget {
  final void Function(bool) onChanged;
  final String text;

  const TextCheckbox({super.key, required this.onChanged, required this.text});

  @override
  State<TextCheckbox> createState() => _TextCheckboxState();
}

class _TextCheckboxState extends State<TextCheckbox> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return CheckboxListTile(
      value: _checked,
      hoverColor: colors.tertiary,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        widget.text,
        style: TextStyle(color: colors.onSecondary.darken(30)),
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
