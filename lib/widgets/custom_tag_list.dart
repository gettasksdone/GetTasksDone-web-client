import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/colors.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:flutter/material.dart';

class CustomTagList extends StatelessWidget {
  static const double _tagTextSize = 17.0;

  final void Function(int? id) onTagAdded;
  final UserData _userData = UserData();
  final List<int> tags;

  CustomTagList({
    super.key,
    required this.onTagAdded,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final List<int> addableTags =
        _userData.tags.keys.where((id) => !tags.contains(id)).toList();
    final ColorScheme colors = context.colorScheme;

    return SizedBox(
      height: 50.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
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
                    _userData.getTag(id)!.name,
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
                      _userData.getTag(id)!.name,
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
      ),
    );
  }
}
