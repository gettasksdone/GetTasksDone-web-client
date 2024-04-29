import 'package:gtd_client/widgets/custom_dismissible.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/providers/inbox_count.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/widgets/task_card.dart';
import 'package:gtd_client/modals/task_modal.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:flutter/material.dart';

class TasksView extends ConsumerStatefulWidget {
  final Task Function()? taskBuilder;
  final bool Function(Task) showTask;
  final bool inboxView;

  const TasksView({
    super.key,
    required this.showTask,
    this.taskBuilder,
    this.inboxView = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TasksViewState();
}

class _TasksViewState extends ConsumerState<TasksView> {
  static final UserData _userData = UserData();

  void _editTask(BuildContext context, Task task) {
    setState(() {
      showModal(
        context,
        ref,
        () => setState(() {}),
        task.copy(),
        _userData.getProjectIdOfTask(task.id),
      );
    });
  }

  void _createTask(BuildContext context) {
    setState(() {
      showModal(
        context,
        ref,
        () => setState(() {}),
        widget.taskBuilder!(),
        null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild inbox view if a task is added
    if (widget.inboxView) {
      final _ = ref.watch(inboxCountProvider);
    }

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
                              CustomDismissible(
                                dimissibleKey: ValueKey(entry.value),
                                onRightSwipe: () async {
                                  await deleteTask(
                                    ref,
                                    entry.key,
                                    () {
                                      _userData.removeTask(ref, entry.key);
                                    },
                                  );
                                },
                                onLeftSwipe: () async {
                                  final Task task = entry.value;
                                  final bool value = task.state != Task.done;

                                  bool updateCount = false;

                                  if (value) {
                                    updateCount = _userData.taskInInbox(task);

                                    task.state = Task.done;
                                  } else {
                                    task.state = Task.start;

                                    updateCount = _userData.taskInInbox(task);
                                  }

                                  await patchTask(
                                    ref,
                                    task,
                                    null,
                                    () => setState(() {
                                      final InboxCount provider =
                                          ref.read(inboxCountProvider.notifier);

                                      if (updateCount) {
                                        if (value) {
                                          provider.substractOne();
                                        } else {
                                          provider.addOne();
                                        }
                                      }

                                      _userData.updateTask(ref, task, null);

                                      setState(() {});
                                    }),
                                  );
                                },
                                child: TaskCard(
                                  task: entry.value,
                                  setParentState: () => setState(() {}),
                                  onPressed: () => _editTask(
                                    context,
                                    entry.value,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.taskBuilder != null,
                    child: Padding(
                      padding: const EdgeInsets.only(top: paddingAmount),
                      child: SolidIconButton(
                        center: true,
                        size: cardElementSize,
                        text: 'Agregar tarea',
                        icon: Icons.add_box_outlined,
                        innerSize: cardElementFontSize,
                        onPressed: () => _createTask(context),
                      ),
                    ),
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
