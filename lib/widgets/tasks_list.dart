import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class TasksListController {
  final Set<int> deletedTasks = {};
  final Set<int> editedTasks = {};
  final List<Task> tasks;

  TasksListController({required this.tasks});
}

class TasksList extends StatefulWidget {
  final TasksListController controller;

  const TasksList({super.key, required this.controller});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  void _onTaskEdited(TasksListController controller, int index) {
    if (controller.tasks[index].id != -1) {
      controller.editedTasks.add(
        controller.tasks[index].id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TasksListController controller = widget.controller;
    final ColorScheme colors = context.colorScheme;
    final DateTime currentTime = DateTime.now();

    return ListView(
      children: [
        for (int i = 0; i < controller.tasks.length; i++)
          Padding(
            padding: rowPadding,
            child: Container(
              decoration: BoxDecoration(
                color: colors.secondary,
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
                              style: TextStyle(color: colors.onSecondary),
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
                                if (controller.tasks[i].id != -1) {
                                  controller.deletedTasks.add(
                                    controller.tasks[i].id,
                                  );
                                }

                                controller.tasks.removeAt(i);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: CustomFormField(
                        label: 'Estado',
                        initialValue: controller.tasks[i].state,
                        validator: (String? input) => notEmptyValidator(
                          input,
                          () {
                            if (controller.tasks[i].state != input) {
                              setState(() {
                                _onTaskEdited(controller, i);

                                controller.tasks[i].state = input;
                              });
                            }
                          },
                        ),
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
                                _onTaskEdited(controller, i);

                                controller.tasks[i].description = input;
                              });
                            }
                          },
                        ),
                      ),
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
              controller.tasks.add(Task(
                created: currentTime,
                expiration: currentTime,
              ));
            });
          },
        ),
      ],
    );
  }
}
