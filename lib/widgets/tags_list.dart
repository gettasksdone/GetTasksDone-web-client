import 'package:gtd_client/widgets/delete_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/colors.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:flutter/material.dart';

class TagsListController {
  late final Set<int> availableTags;
  final Set<int> tags;

  void addTag(int id) {
    tags.add(id);
    availableTags.remove(id);
  }

  void removeTag(int id) {
    tags.remove(id);
    availableTags.add(id);
  }

  TagsListController({required this.tags}) {
    availableTags =
        UserData().tags.keys.where((id) => !tags.contains(id)).toSet();
  }
}

class TagsList extends StatefulWidget {
  final TagsListController controller;

  const TagsList({super.key, required this.controller});

  @override
  State<TagsList> createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  static final UserData _userData = UserData();
  static const double _tagTextSize = 17.0;

  @override
  Widget build(BuildContext context) {
    final TagsListController controller = widget.controller;
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
          for (final int id in controller.tags)
            Padding(
              padding: const EdgeInsets.only(right: paddingAmount),
              child: Container(
                decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: roundedCorners,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.5),
                  child: Row(
                    children: [
                      Text(
                        _userData.getTag(id).name!,
                        style: TextStyle(
                          fontSize: _tagTextSize,
                          color: colors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      DeleteButton(onPressed: () {
                        setState(() {
                          controller.removeTag(id);
                        });
                      }),
                    ],
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
                onChanged: (int? id) {
                  if (id != null) {
                    setState(() {
                      controller.addTag(id);
                    });
                  }
                },
                borderRadius: roundedCorners,
                icon: const Icon(Icons.arrow_drop_down),
                hint: const Padding(
                  padding: EdgeInsets.only(left: 22.0),
                  child: Icon(
                    Icons.add_box_rounded,
                    size: 28.0,
                  ),
                ),
                items: controller.availableTags.map<DropdownMenuItem<int>>(
                  (int id) {
                    return DropdownMenuItem(
                      value: id,
                      child: Text(
                        _userData.getTag(id).name!,
                        style: TextStyle(
                          fontSize: _tagTextSize,
                          color: colors.onPrimary,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
