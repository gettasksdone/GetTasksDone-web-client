import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/widgets/task_card.dart';
import 'package:gtd_client/modals/task_modal.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class TasksView extends ConsumerStatefulWidget {
  final bool Function(Task) showTask;

  const TasksView({super.key, required this.showTask});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TasksViewState();
}

class _TasksViewState extends ConsumerState<TasksView> {
  static final UserData _userData = UserData();

  void _editTask(BuildContext context, Task task) {
    setState(() {
      showModal(context, ref, () => setState(() {}), task);
    });
  }

  void _createTask(BuildContext context) {
    setState(() {
      showModal(context, ref, () => setState(() {}), null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    final List<MapEntry<int, Task>> tasks = [];

    for (final int id in _userData.tasks.keys) {
      final Task task = _userData.getTask(id);

      if (widget.showTask(task)) {
        tasks.add(MapEntry(id, task));
      }
    }

    tasks.sort((entryA, entryB) {
      final DateTime dateCreatedA = entryA.value.created;
      final DateTime dateCreatedB = entryB.value.created;

      if (dateCreatedA.isBefore(dateCreatedB)) {
        return -1;
      }

      if (dateCreatedB.isBefore(dateCreatedA)) {
        return 1;
      }

      return 0;
    });

    return Center(
      child: Padding(
        padding: viewPadding,
        child: SizedBox(
          width: 700.0,
          height: 600.0,
          child: Container(
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: roundedCorners,
            ),
            child: Padding(
              padding: cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: rowPadding,
                    child: Text(
                      'Tus tareas',
                      style: TextStyle(fontSize: 23.0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: rowPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.tertiary,
                          borderRadius: roundedCorners,
                        ),
                        child: Padding(
                          padding: cardPadding,
                          child: ListView(
                            children: [
                              for (final MapEntry<int, Task> entry in tasks)
                                TaskCard(
                                  task: entry.value,
                                  setParentState: () => setState(() {}),
                                  onPressed: () => _editTask(
                                    context,
                                    entry.value,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SolidIconButton(
                    center: true,
                    size: cardElementSize,
                    text: 'Agregar tarea',
                    icon: Icons.add_box_outlined,
                    innerSize: cardElementFontSize,
                    onPressed: () => _createTask(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
