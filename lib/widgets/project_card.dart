import 'package:gtd_client/widgets/text_with_icon.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/widgets/task_card.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatefulWidget {
  final void Function(Task)? onTaskPressed;
  final VoidCallback setParentState;
  final VoidCallback? onAddTask;
  final VoidCallback? onEdit;
  final Project project;

  const ProjectCard({
    super.key,
    required this.setParentState,
    required this.project,
    this.onTaskPressed,
    this.onAddTask,
    this.onEdit,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  static final UserData _userData = UserData();

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Color canvasColor = context.theme.canvasColor;

    return Padding(
      padding: rowPadding,
      child: ListTileTheme(
        minVerticalPadding: 0.0,
        child: ExpansionTile(
          shape: roundedBorder,
          backgroundColor: canvasColor,
          collapsedShape: roundedBorder,
          collapsedBackgroundColor: canvasColor,
          enabled: widget.project.tasks.isNotEmpty,
          onExpansionChanged: (value) => setState(() {
            _expanded = value;
          }),
          title: Row(
            children: [
              Expanded(
                child: TextWithIcon(
                  icon: Icons.personal_video,
                  text: widget.project.name!,
                ),
              ),
              IconButton(
                onPressed: widget.onEdit,
                icon: Icon(
                  Icons.edit,
                  color: colors.onTertiary,
                ),
                style: IconButton.styleFrom(
                  shape: roundedBorder,
                  backgroundColor: colors.tertiary,
                ),
              ),
              const SizedBox(width: paddingAmount),
              IconButton(
                onPressed: widget.onAddTask,
                icon: Icon(
                  Icons.add_outlined,
                  color: colors.onPrimary,
                ),
                style: IconButton.styleFrom(
                  shape: roundedBorder,
                  backgroundColor: colors.primary,
                ),
              ),
            ],
          ),
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: paddingAmount,
          ),
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
          children: widget.project.tasks.map((id) {
            final Task task = _userData.getTask(id);

            return TaskCard(
              task: task,
              setParentState: widget.setParentState,
              onPressed: () => widget.onTaskPressed!(task),
            );
          }).toList(),
        ),
      ),
    );
  }
}
