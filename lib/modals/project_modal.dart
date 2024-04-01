import 'package:gtd_client/modals/custom_date_picker.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/widgets/notes_list.dart';
import 'package:gtd_client/widgets/tasks_list.dart';
import 'package:gtd_client/widgets/tags_list.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:flutter/material.dart';

const int _notesFlex = 2;

const int _tasksFlex = 5;

const int _fieldsFlex = 3;

void showModal(BuildContext context, Project? selectedProject) {
  final TextStyle titleStyle = TextStyle(
    color: context.colorScheme.onSecondary,
    fontSize: cardElementFontSize,
    fontWeight: FontWeight.w600,
  );
  final bool existingProject = selectedProject != null;
  final Project project = selectedProject ?? Project();
  final UserData userData = UserData();

  final NotesListController notesController = NotesListController(
    notes: project.notes.map((id) => userData.getNote(id)).toList(),
  );
  final TasksListController tasksController = TasksListController(
    tasks: project.tasks.map((id) => userData.getTask(id)).toList(),
  );
  final TagsListController tagsController = TagsListController(
    tags: project.tags,
  );

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, dialogSetState) {
          final String parsedStartDate = project.startDate.toCustomFormat;
          final String parsedEndDate = project.finishDate.toCustomFormat;

          return CustomModal(
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: _fieldsFlex,
                      child: CustomFormField(
                        label: 'Nombre',
                        hintText: 'nombre',
                        initialValue: project.name,
                        validator: (String? input) => notEmptyValidator(
                          input,
                          () => dialogSetState(() {
                            project.name = input;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingAmount),
                    Expanded(
                      flex: _notesFlex,
                      child: Center(
                        child: Text(
                          'Notas',
                          style: titleStyle,
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingAmount),
                    Expanded(
                      flex: _tasksFlex,
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
                  flex: _fieldsFlex,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: rowPadding,
                        child: TagsList(controller: tagsController),
                      ),
                      Padding(
                        padding: rowPadding,
                        child: CustomFormField(
                          label: 'Estado',
                          hintText: 'estado',
                          initialValue: project.state,
                          validator: (String? input) => notEmptyValidator(
                            input,
                            () => dialogSetState(() {
                              project.state = input;
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
                            initialValue: project.description,
                            validator: (String? input) => notEmptyValidator(
                              input,
                              () => dialogSetState(() {
                                project.description = input!;
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
                                  final DateTime? date =
                                      await showCustomDatePicker(
                                    context: context,
                                    finishDate: project.finishDate,
                                  );

                                  if (date != null) {
                                    dialogSetState(() {
                                      project.setStart(date);
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
                                  final DateTime? date =
                                      await showCustomDatePicker(
                                    context: context,
                                    startDate: project.startDate,
                                  );

                                  if (date != null) {
                                    dialogSetState(() {
                                      project.setFinish(date);
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
                                existingProject ? 'Guardar' : 'Crear',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: modalButtonFontSize,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          if (existingProject)
                            const SizedBox(width: paddingAmount),
                          if (existingProject)
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
                  flex: _notesFlex,
                  child: NotesList(controller: notesController),
                ),
                const SizedBox(width: paddingAmount),
                Expanded(
                  flex: _tasksFlex,
                  child: TasksList(controller: tasksController),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
