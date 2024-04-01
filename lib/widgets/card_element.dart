import 'package:gtd_client/widgets/text_with_icon.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/colors.dart';
import 'package:flutter/material.dart';

class CardCellData {
  final double? width;
  final IconData icon;
  final String text;

  CardCellData({required this.icon, required this.text, this.width});
}

class CardElement extends StatelessWidget {
  final List<CardCellData> cells;
  final VoidCallback onPressed;

  const CardElement({super.key, required this.cells, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: rowPadding,
      child: SolidButton(
        leftAligned: true,
        onPressed: onPressed,
        size: cardElementSize,
        color: getRandomColor(),
        withWidget: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                child: TextWithIcon(
                  icon: cells[0].icon,
                  text: cells[0].text,
                ),
              ),
              for (int i = 1; i < cells.length; i++)
                Padding(
                  padding: const EdgeInsets.only(left: paddingAmount),
                  child: SizedBox(
                    width: cells[i].width,
                    child: TextWithIcon(
                      icon: cells[i].icon,
                      text: cells[i].text,
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
