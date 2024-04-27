import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/widgets/text_with_icon.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/widgets/task_card.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class ProjectCard extends ConsumerStatefulWidget {
  final void Function(Task)? onTaskPresed;
  final VoidCallback setParentState;
  final VoidCallback? onPressed;
  final Project project;

  const ProjectCard({
    super.key,
    required this.setParentState,
    required this.project,
    this.onTaskPresed,
    this.onPressed,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<ProjectCard> {
  static final UserData _userData = UserData();

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Color darkerSecondary = colors.secondary.darken(10);

    return Padding(
      padding: rowPadding,
      child: ListTileTheme(
        minVerticalPadding: 0.0,
        child: ExpansionTile(
          shape: roundedBorder,
          collapsedShape: roundedBorder,
          backgroundColor: darkerSecondary,
          collapsedBackgroundColor: darkerSecondary,
          tilePadding: const EdgeInsets.only(right: paddingAmount),
          childrenPadding: const EdgeInsets.only(
            top: paddingAmount,
            left: paddingAmount,
            right: paddingAmount,
          ),
          trailing: Icon(
            _expanded
                ? Icons.arrow_drop_down_circle_outlined
                : Icons.arrow_drop_down_circle,
            size: 27.0,
            color: colors.onSurface,
          ),
          title: SolidButton(
            leftAligned: true,
            size: cardElementSize,
            color: colors.secondary,
            onPressed: widget.onPressed,
            withWidget: TextWithIcon(
              icon: Icons.personal_video,
              text: widget.project.name!,
            ),
          ),
          onExpansionChanged: (value) => setState(() {
            _expanded = value;
          }),
          children: widget.project.tasks.map((id) {
            final Task task = _userData.getTask(id);

            return TaskCard(
              task: task,
              setParentState: widget.setParentState,
              onPressed: () => widget.onTaskPresed!(task),
            );
          }).toList(),
        ),
      ),
    );
  }
}
