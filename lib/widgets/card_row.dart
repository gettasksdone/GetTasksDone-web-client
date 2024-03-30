import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/colors.dart';
import 'package:flutter/material.dart';

class CardRowCellData {
  final double? width;
  final IconData icon;
  final String text;

  CardRowCellData({required this.icon, required this.text, this.width});
}

class CardRow extends StatelessWidget {
  final List<CardRowCellData> cells;
  final VoidCallback onPressed;

  const CardRow({super.key, required this.cells, required this.onPressed});

  Widget _textWithIcon(Color color, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(width: smallPaddingAmount),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: elementCardFontSize,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Padding(
      padding: rowPadding,
      child: SolidButton(
        leftAligned: true,
        onPressed: onPressed,
        size: elementCardSize,
        color: getRandomColor(),
        withWidget: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                child: _textWithIcon(
                  colors.onPrimary,
                  cells[0].icon,
                  cells[0].text,
                ),
              ),
              for (int i = 1; i < cells.length; i++)
                Padding(
                  padding: const EdgeInsets.only(left: paddingAmount),
                  child: SizedBox(
                    width: cells[i].width,
                    child: _textWithIcon(
                      colors.onPrimary,
                      cells[i].icon,
                      cells[i].text,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
