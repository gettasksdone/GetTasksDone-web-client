import 'package:gtd_client/modals/custom_date_picker.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/custom_note_list.dart';
import 'package:gtd_client/widgets/custom_tag_list.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:flutter/material.dart';

void showModal(BuildContext context, Project? selectedProject) {
  final TextStyle titleStyle = TextStyle(
    fontSize: elementCardFontSize,
    color: context.colorScheme.onSecondary,
    fontWeight: FontWeight.w600,
  );
  final bool hasProject = selectedProject != null;
  final UserData userData = UserData();
  final List<Note> notes;
  final List<int> tasks;
  final List<int> tags;

  String? description;
  DateTime finishDate;
  DateTime startDate;
  String? state;
  String? name;

  if (hasProject) {
    notes = selectedProject.notes.map((i) => userData.getNote(i)!).toList();
    description = selectedProject.description;
    finishDate = selectedProject.finishDate;
    startDate = selectedProject.startDate;
    state = selectedProject.state;
    tasks = selectedProject.tasks;
    name = selectedProject.name;
    tags = selectedProject.tags;
  } else {
    final DateTime currentTime = DateTime.now();

    finishDate = currentTime;
    startDate = currentTime;
    tasks = [];
    notes = [];
    tags = [];
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, dialogSetState) {
          final String parsedStartDate = startDate.toCustomFormat;
          final String parsedEndDate = finishDate.toCustomFormat;

          return CustomModal(
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: modalFieldsFlex,
                      child: CustomFormField(
                        label: 'Nombre',
                        hintText: 'nombre',
                        initialValue: name,
                        validator: (String? input) => notEmptyValidator(
                          input,
                          'Introduzca nombre del proyecto',
                          () => dialogSetState(() {
                            name = input!;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingAmount),
                    Expanded(
                      flex: modalRightFlex,
                      child: Center(
                        child: Text(
                          'Notas',
                          style: titleStyle,
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingAmount),
                    Expanded(
                      flex: modalRightFlex,
                      child: Center(
                        child: Text(
                          'Tareas',
                          style: titleStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bodyWidget: Row(
              children: [
                Expanded(
                  flex: modalFieldsFlex,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: rowPadding,
                        child: CustomTagList(
                          tags: tags,
                          onTagAdded: (int? id) {
                            if (id != null) {
                              dialogSetState(
                                () {
                                  tags.add(id);
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: rowPadding,
                        child: CustomFormField(
                          label: 'Estado',
                          hintText: 'estado',
                          initialValue: state,
                          validator: (String? input) => notEmptyValidator(
                            input,
                            'Introduzca estado del proyecto',
                            () => dialogSetState(() {
                              state = input!;
                            }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: rowPadding,
                          child: CustomFormField(
                            expands: true,
                            label: 'Descripción',
                            hintText: 'descripción',
                            initialValue: description,
                            validator: (String? input) => notEmptyValidator(
                              input,
                              'Introduzca descripción del proyecto',
                              () => dialogSetState(() {
                                description = input!;
                              }),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: rowPadding,
                        child: Row(
                          children: [
                            Expanded(
                              child: SolidButton(
                                size: modalButtonSize,
                                text: 'Inicio $parsedStartDate',
                                onPressed: () async {
                                  final DateTime? result =
                                      await showCustomDatePicker(
                                    context: context,
                                    finishDate: finishDate,
                                  );

                                  if (result != null) {
                                    dialogSetState(() {
                                      startDate = result;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: paddingAmount),
                            Expanded(
                              child: SolidButton(
                                size: modalButtonSize,
                                text: 'Final $parsedEndDate',
                                onPressed: () async {
                                  final DateTime? result =
                                      await showCustomDatePicker(
                                    context: context,
                                    startDate: startDate,
                                  );

                                  if (result != null) {
                                    dialogSetState(() {
                                      finishDate = result;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SolidButton(
                              color: Colors.green,
                              size: modalButtonSize,
                              withWidget: Text(
                                hasProject ? 'Guardar' : 'Crear',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: modalButtonFontSize,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          if (hasProject) const SizedBox(width: paddingAmount),
                          if (hasProject)
                            Expanded(
                              child: SolidButton(
                                color: Colors.red,
                                size: modalButtonSize,
                                withWidget: const Text(
                                  'Borrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: modalButtonFontSize,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: paddingAmount),
                Expanded(
                  flex: modalRightFlex,
                  child: CustomNoteList(
                    notes: notes,
                    onNoteDeleted: (i) {
                      dialogSetState(() {
                        notes.removeAt(i);
                      });
                    },
                    onNoteCreated: () {
                      dialogSetState(() {
                        notes.add(Note(content: ''));
                      });
                    },
                    onNoteEdited: (i, input) {
                      dialogSetState(() {
                        notes[i].content = input ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: paddingAmount),
                const Expanded(
                  flex: modalRightFlex,
                  child: Placeholder(),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
