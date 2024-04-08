import 'package:gtd_client/modals/custom_date_picker.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/widgets/check_items_list.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/widgets/notes_list.dart';
import 'package:gtd_client/widgets/tags_list.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class TasksListController {
  final List<CheckItemsListController> taskCheckItemsControllers = [];
  final List<NotesListController> taskNotesControllers = [];
  final List<TagsListController> taskTagsControllers = [];

  final Set<int> _deletedTasks = {};
  final Set<int> _editedTasks = {};
  late final List<Task> tasks;

  Set<int> get deletedTasks => _deletedTasks;
  Set<int> get editedTasks => _editedTasks;

  void addTask() {
    taskCheckItemsControllers.add(
      CheckItemsListController(checkItemIds: {}),
    );
    taskNotesControllers.add(NotesListController(noteIds: {}));
    taskTagsControllers.add(TagsListController(tags: {}));
    tasks.add(Task(expiration: DateTime.now()));
  }

  void setTaskAsEdited(int index) {
    if (tasks[index].id != -1) {
      _editedTasks.add(tasks[index].id);
    }
  }

  void removeTask(int index) {
    taskCheckItemsControllers.removeAt(index);
    taskNotesControllers.removeAt(index);
    taskTagsControllers.removeAt(index);

    if (tasks[index].id != -1) {
      _deletedTasks.add(tasks[index].id);
    }

    tasks.removeAt(index);
  }

  TasksListController({required Set<int> taskIds}) {
    tasks = taskIds.map((id) => UserData().getTask(id)).toList();

    for (final Task task in tasks) {
      taskCheckItemsControllers.add(
        CheckItemsListController(checkItemIds: task.checkItems),
      );
      taskNotesControllers.add(NotesListController(noteIds: task.notes));
      taskTagsControllers.add(TagsListController(tags: task.tags));
    }
  }
}

class TasksList extends StatefulWidget {
  final TasksListController controller;

  const TasksList({super.key, required this.controller});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    final TasksListController controller = widget.controller;
    final ColorScheme colors = context.colorScheme;

    return ListView(
      children: [
        for (int i = 0; i < controller.tasks.length; i++)
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
                              controller.tasks[i].created.toCustomFormat,
                              style: TextStyle(color: colors.onTertiary),
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: colors.errorContainer,
                            ),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                controller.removeTask(i);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: TagsList(
                        controller: controller.taskTagsControllers[i],
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField(
                                menuMaxHeight: 400.0,
                                value: controller.tasks[i].contextId,
                                style: TextStyle(color: colors.onTertiary),
                                decoration: InputDecoration(
                                  labelText: 'Contexto',
                                  labelStyle: TextStyle(
                                    color: colors.onTertiary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: roundedCorners,
                                    borderSide: BorderSide(
                                      width: edgeWidth,
                                      color: colors.primary,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: roundedCorners,
                                    borderSide: BorderSide(
                                      width: edgeWidth,
                                      color: colors.primary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: roundedCorners,
                                    borderSide: BorderSide(
                                      width: edgeWidth,
                                      color: colors.primary.darken(20),
                                    ),
                                  ),
                                ),
                                onChanged: (int? id) {
                                  if (id != null) {
                                    setState(() {
                                      controller.setTaskAsEdited(i);

                                      controller.tasks[i].contextId = id;
                                    });
                                  }
                                },
                                items: UserData().contexts.entries.map(
                                  (entry) {
                                    return DropdownMenuItem<int>(
                                      value: entry.key,
                                      child: Text(entry.value.name!),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            const SizedBox(width: paddingAmount),
                            Expanded(
                              child: SolidButton(
                                text:
                                    'Final ${controller.tasks[i].expiration!.toCustomFormat}',
                                onPressed: () async {
                                  final DateTime? date =
                                      await showCustomDatePicker(
                                    context: context,
                                    startDate: controller.tasks[i].created,
                                  );

                                  if (date != null) {
                                    setState(() {
                                      controller.tasks[i].setExpiration(date);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomFormField(
                              label: 'Estado',
                              initialValue: controller.tasks[i].state,
                              validator: (String? input) => notEmptyValidator(
                                input,
                                () {
                                  if (controller.tasks[i].state != input) {
                                    setState(() {
                                      controller.setTaskAsEdited(i);

                                      controller.tasks[i].state = input;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: paddingAmount),
                          Expanded(
                            child: CustomFormField(
                              numeric: true,
                              label: 'Prioridad',
                              initialValue:
                                  controller.tasks[i].priority?.toString(),
                              validator: (String? input) => notEmptyValidator(
                                input,
                                () {
                                  final int parsed = int.parse(input!);

                                  if (controller.tasks[i].priority != parsed) {
                                    setState(() {
                                      controller.setTaskAsEdited(i);

                                      controller.tasks[i].priority = parsed;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: CustomFormField(
                        multiline: true,
                        label: 'Descripción',
                        initialValue: controller.tasks[i].description,
                        validator: (String? input) => notEmptyValidator(
                          input,
                          () {
                            if (controller.tasks[i].description != input) {
                              setState(() {
                                controller.setTaskAsEdited(i);

                                controller.tasks[i].description = input;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          borderRadius: roundedCorners,
                        ),
                        child: Padding(
                          padding: padding,
                          child: NotesList(
                            asColumn: true,
                            controller: controller.taskNotesControllers[i],
                          ),
                        ),
                      ),
                    ),
                    CheckItemsList(
                      controller: controller.taskCheckItemsControllers[i],
                    ),
                  ],
                ),
              ),
            ),
          ),
        SolidIconButton(
          center: true,
          text: 'Agregar tarea',
          size: modalButtonSize,
          icon: Icons.add_box_outlined,
          onPressed: () {
            setState(() {
              controller.addTask();
            });
          },
        ),
      ],
    );
  }
}
