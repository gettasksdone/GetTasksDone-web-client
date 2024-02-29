import 'package:gtd_client/widgets/custom_text_button.dart';
import 'package:gtd_client/widgets/checkbox_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/enums/task_length.dart';
import 'package:gtd_client/enums/task_date.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  static const EdgeInsets _rowPadding = EdgeInsets.only(bottom: 20.0);
  static const double _editButtonSize = 59.0;

  List<Task> _tasks = [
    Task(
      when: DateTime(2024, 2, 29, 9),
      length: TaskLength.minutes15,
      category: TaskDate.saved,
      name: "Hacer la cama",
      tag: "DOMÉSTICO",
      recurring: true,
    ),
    Task(
      when: DateTime(2024, 2, 29, 10),
      length: TaskLength.hours1,
      category: TaskDate.saved,
      name: "Ir a clase",
      tag: "UNIVERSIDAD",
      recurring: true,
    ),
  ];
  int _editTaskIndex = 0;
  bool _editTask = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    if (_editTask) {
      return Center(
        child: Text('Index: $_editTaskIndex'),
      );
    }

    return Center(
      child: SizedBox(
        width: 350.0,
        height: 400.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: _rowPadding,
              child: Text(
                'Tus tareas',
                style: TextStyle(
                  fontSize: 23.0,
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            for (int i = 0; i < _tasks.length; i++)
              Padding(
                padding: _rowPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: CheckboxButton(
                        text: _tasks[i].name,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    SizedBox(
                      width: _editButtonSize,
                      height: _editButtonSize,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        style: IconButton.styleFrom(
                          backgroundColor: colors.onSurface.lighten(80),
                          shape: const RoundedRectangleBorder(
                            borderRadius: roundedCorners,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _editTaskIndex = i;
                            _editTask = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 50.0),
            const CustomIconButton(
              label: 'Agregar tarea',
              icon: Icons.add_box_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
