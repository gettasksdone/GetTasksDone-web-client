import 'package:gtd_client/widgets/checkbox_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gtd_client/widgets/custom_icon_button.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  static const EdgeInsets _rowPadding = EdgeInsets.only(bottom: 20.0);

  List<String> _tasks = ['Hacer la cama', 'Ir a clase'];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

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
            for (String task in _tasks)
              Padding(
                padding: _rowPadding,
                child: CheckboxButton(
                  text: task,
                  onChanged: (value) {},
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
