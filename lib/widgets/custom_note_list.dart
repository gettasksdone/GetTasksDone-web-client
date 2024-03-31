import 'package:flutter/material.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';

class CustomNoteList extends StatelessWidget {
  final void Function(int index, String? content) onNoteEdited;
  final void Function(int index) onNoteDeleted;
  final void Function() onNoteCreated;
  final List<Note> notes;

  const CustomNoteList({
    super.key,
    required this.onNoteCreated,
    required this.onNoteDeleted,
    required this.onNoteEdited,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return ListView(
      children: [
        for (int i = 0; i < notes.length; i++)
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
                              notes[i].created.toCustomFormat,
                              style: TextStyle(color: colors.onSecondary),
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.darken(30),
                            ),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () => onNoteDeleted(i),
                          ),
                        ],
                      ),
                    ),
                    CustomFormField(
                      multiline: true,
                      initialValue: notes[i].content,
                      validator: (String? input) {
                        onNoteEdited(i, input);

                        return null;
                      },
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
          onPressed: onNoteCreated,
        ),
      ],
    );
  }
}
