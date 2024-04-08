import 'package:gtd_client/widgets/checkbox_text_field.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:flutter/material.dart';

class CheckItemsListController {
  final Set<int> _deletedCheckItems = {};
  final Set<int> _editedCheckItems = {};
  late final List<CheckItem> checkItems;

  Set<int> get deletedCheckItems => _deletedCheckItems;
  Set<int> get editedCheckItems => _editedCheckItems;

  void addCheckItem() {
    checkItems.add(CheckItem());
  }

  void setCheckItemAsEdited(int index) {
    if (checkItems[index].id != -1) {
      _editedCheckItems.add(checkItems[index].id);
    }
  }

  void removeCheckItem(int index) {
    if (checkItems[index].id != -1) {
      _deletedCheckItems.add(checkItems[index].id);
    }

    checkItems.removeAt(index);
  }

  CheckItemsListController({required Set<int> checkItemIds}) {
    checkItems = checkItemIds.map((id) => UserData().getCheckItem(id)).toList();
  }
}

class CheckItemsList extends StatefulWidget {
  final CheckItemsListController controller;

  const CheckItemsList({super.key, required this.controller});

  @override
  State<CheckItemsList> createState() => _CheckItemsListState();
}

class _CheckItemsListState extends State<CheckItemsList> {
  @override
  Widget build(BuildContext context) {
    final CheckItemsListController controller = widget.controller;

    return Column(
      children: [
        for (int i = 0; i < controller.checkItems.length; i++)
          CheckboxTextField(
            text: controller.checkItems[i].content!,
            onChanged: (bool check) {
              setState(() {
                controller.setCheckItemAsEdited(i);

                controller.checkItems[i].checked = check;
              });
            },
          ),
        SolidIconButton(
          center: true,
          text: 'Agregar subtarea',
          size: modalButtonSize,
          icon: Icons.add_box_outlined,
          onPressed: () {
            setState(() {
              controller.addCheckItem();
            });
          },
        ),
      ],
    );
  }
}
