import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class CustomTaskList extends StatelessWidget {
  final void Function(int index, Task task) onTaskEdited;
  final void Function(int index) onTaskDeleted;
  final void Function() onTaskCreated;
  final List<Task> tasks;

  const CustomTaskList({
    super.key,
    required this.onTaskCreated,
    required this.onTaskDeleted,
    required this.onTaskEdited,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return ListView(
      children: [
        for (int i = 0; i < tasks.length; i++)
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
                              tasks[i].created.toCustomFormat,
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
                            onPressed: () => onTaskDeleted(i),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: CustomFormField(
                        label: 'Estado',
                        initialValue: tasks[i].state,
                        validator: (String? input) {
                          tasks[i].state = input ?? '';

                          onTaskEdited(i, tasks[i]);

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: rowPadding,
                      child: CustomFormField(
                        multiline: true,
                        label: 'Descripción',
                        initialValue: tasks[i].description,
                        validator: (String? input) {
                          tasks[i].description = input ?? '';

                          onTaskEdited(i, tasks[i]);

                          return null;
                        },
                      ),
                    ),
                    CustomFormField(
                      multiline: true,
                      initialValue: tasks[i].content,
                      validator: (String? input) {
                        onTaskEdited(i, input);

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
          onPressed: onTaskCreated,
        ),
      ],
    );
  }
}
