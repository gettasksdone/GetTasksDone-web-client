import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/providers/inbox_count.dart';
import 'package:gtd_client/widgets/text_with_icon.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:flutter/material.dart';

class TaskCard extends ConsumerStatefulWidget {
  final VoidCallback setParentState;
  final VoidCallback? onPressed;
  final Task task;

  const TaskCard({
    super.key,
    required this.setParentState,
    required this.task,
    this.onPressed,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  static final UserData _userData = UserData();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Padding(
      padding: rowPadding,
      child: SolidButton(
        leftAligned: true,
        size: cardElementSize,
        color: colors.secondary,
        onPressed: widget.onPressed,
        withWidget: Padding(
          padding: cardInnerPadding,
          child: Row(
            children: [
              Checkbox(
                shape: const CircleBorder(),
                checkColor: colors.onPrimary,
                value: widget.task.state == Task.done,
                side: BorderSide(
                  width: 2.0,
                  color: colors.onSecondary,
                ),
                onChanged: (bool? value) async {
                  bool updateCount = false;

                  if (value!) {
                    updateCount = _userData.taskInInbox(widget.task);

                    widget.task.state = Task.done;
                  } else {
                    widget.task.state = Task.start;

                    updateCount = _userData.taskInInbox(widget.task);
                  }

                  await patchTask(
                    ref,
                    widget.task,
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

                      _userData.updateTask(ref, widget.task, null);

                      widget.setParentState();
                    }),
                  );
                },
              ),
              const SizedBox(width: paddingAmount),
              Expanded(
                child: TextWithIcon(
                  icon: Icons.folder,
                  text: widget.task.title!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
