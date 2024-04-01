import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/widgets/delete_button.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:flutter/material.dart';

class NotesListController {
  final Set<int> deletedNotes = {};
  final Set<int> editedNotes = {};
  final List<Note> notes;

  NotesListController({required this.notes});
}

class NotesList extends StatefulWidget {
  final NotesListController controller;
  final bool asColumn;

  const NotesList({
    super.key,
    required this.controller,
    this.asColumn = false,
  });

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    final NotesListController controller = widget.controller;
    final ColorScheme colors = context.colorScheme;

    final List<Widget> children = [
      for (int i = 0; i < controller.notes.length; i++)
        Padding(
          padding: rowPadding,
          child: Container(
            decoration: BoxDecoration(
              color: colors.tertiary,
              borderRadius: roundedCorners,
            ),
            child: Padding(
              padding: padding,
              child: Column(
                children: [
                  Padding(
                    padding: rowPadding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            controller.notes[i].created.toCustomFormat,
                            style: TextStyle(color: colors.onSecondary),
                          ),
                        ),
                        DeleteButton(
                          onPressed: () {
                            setState(() {
                              if (controller.notes[i].id != -1) {
                                controller.deletedNotes.add(
                                  controller.notes[i].id,
                                );
                              }

                              controller.notes.removeAt(i);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  CustomFormField(
                    multiline: true,
                    initialValue: controller.notes[i].content,
                    validator: (String? input) => notEmptyValidator(
                      input,
                      () {
                        if (controller.notes[i].content != input) {
                          setState(() {
                            if (controller.notes[i].id != -1) {
                              controller.editedNotes
                                  .add(controller.notes[i].id);
                            }

                            controller.notes[i].content = input;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      SolidIconButton(
        center: true,
        text: 'Agregar nota',
        size: modalButtonSize,
        icon: Icons.add_box_outlined,
        onPressed: () {
          setState(() {
            controller.notes.add(Note());
          });
        },
      ),
    ];

    if (widget.asColumn) {
      return Column(children: children);
    }

    return ListView(children: children);
  }
}
