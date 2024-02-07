import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? labelText;
  final T selectedValue;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    this.onChanged,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = context.darkerSecondary;
    final ColorScheme colors = context.colorScheme;
    final InputBorder border = OutlineInputBorder(
      borderRadius: roundedCorners,
      borderSide: BorderSide(
        width: edgeWidth,
        color: secondaryColor,
      ),
    );

    return DropdownButtonFormField(
      items: items,
      value: selectedValue,
      onChanged: onChanged,
      menuMaxHeight: 400.0,
      style: TextStyle(
        fontSize: 17.0,
        color: colors.onSecondary,
      ),
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        labelText: labelText,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelStyle: TextStyle(
          color: secondaryColor,
          fontSize: labelFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
