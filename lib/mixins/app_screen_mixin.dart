import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:flutter/material.dart';
import 'dart:math';

mixin AppScreenMixin<T extends StatefulWidget> on State<T> {
  static const double _tagTextSize = 17.0;

  final GlobalKey _formKey = GlobalKey<FormState>();
  final UserData userData = UserData();
  final Random _random = Random();

  String? notEmptyValidator(String? input, String errorMessage) {
    if (input == null || input.isEmpty) {
      return errorMessage;
    }

    return null;
  }

  Color getRandomColor() {
    return Colors.primaries[_random.nextInt(Colors.primaries.length)];
  }

  Widget getTagsWidget(
    BuildContext context,
    List<int> tags,
    void Function(int? id) onTagAdded,
  ) {
    final List<int> addableTags =
        userData.tags.keys.where((id) => !tags.contains(id)).toList();
    final ColorScheme colors = context.colorScheme;

    return Row(
      children: [
        Icon(
          Icons.label,
          size: 45.0,
          color: colors.primary,
        ),
        const SizedBox(width: 15.0),
        for (final int id in tags)
          Padding(
            padding: const EdgeInsets.only(right: paddingAmount),
            child: Container(
              decoration: BoxDecoration(
                color: getRandomColor(),
                borderRadius: roundedCorners,
              ),
              child: Padding(
                padding: const EdgeInsets.all(11.5),
                child: Text(
                  userData.getTag(id)!.name,
                  style: TextStyle(
                    fontSize: _tagTextSize,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        Container(
          width: 80.0,
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: roundedCorners,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              onChanged: onTagAdded,
              borderRadius: roundedCorners,
              icon: const Icon(Icons.arrow_drop_down),
              hint: const Padding(
                padding: EdgeInsets.only(left: 22.0),
                child: Icon(
                  Icons.add_box_rounded,
                  size: 28.0,
                ),
              ),
              items: addableTags.map<DropdownMenuItem<int>>((int id) {
                return DropdownMenuItem(
                  value: id,
                  child: Text(
                    userData.getTag(id)!.name,
                    style: TextStyle(
                      fontSize: _tagTextSize,
                      color: colors.onPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  void showModal(
    BuildContext context,
    Widget? titleWidget,
    Widget? bodyWidget,
  ) {
    final ColorScheme colors = context.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
          backgroundColor: context.theme.canvasColor,
          surfaceTintColor: Colors.transparent,
          child: SizedBox(
            width: modalSize.width,
            height: modalSize.height,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: modalHeaderHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        borderRadius: const BorderRadius.vertical(
                          top: cornerRadius,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: cardPadding,
                          child: titleWidget,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: cardPadding,
                    child: bodyWidget,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
