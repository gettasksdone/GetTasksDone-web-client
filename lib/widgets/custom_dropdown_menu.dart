import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> entries;
  final void Function(T?)? onSelected;
  final T? initialSelection;
  final String label;
  final double width;

  const CustomDropdownMenu({
    super.key,
    required this.initialSelection,
    required this.entries,
    required this.label,
    required this.width,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return DropdownMenu(
      width: width,
      initialSelection: initialSelection,
      label: Text(
        label,
        style: TextStyle(color: colors.onTertiary),
      ),
      onSelected: onSelected,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          context.theme.canvasColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: roundedCorners,
          borderSide: BorderSide(
            width: edgeWidth,
            color: colors.primary,
          ),
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
      ),
      dropdownMenuEntries: entries,
    );
  }
}
