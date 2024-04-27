import 'package:gtd_client/modals/project_modal.dart' as project_modal;
import 'package:gtd_client/modals/task_modal.dart' as task_modal;
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/widgets/project_card.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

class ProjectsView extends ConsumerStatefulWidget {
  const ProjectsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  static final UserData _userData = UserData();

  void _editProject(BuildContext context, Project project) {
    setState(() {
      project_modal.showModal(context, ref, () => setState(() {}), project);
    });
  }

  void _createProject(BuildContext context) {
    setState(() {
      project_modal.showModal(context, ref, () => setState(() {}), null);
    });
  }

  void _editTask(BuildContext context, Task task) {
    setState(() {
      task_modal.showModal(context, ref, () => setState(() {}), task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    final List<MapEntry<int, Project>> projects = [];

    for (final MapEntry<int, Project> entry in _userData.projects.entries) {
      if (entry.value.name! != 'inbox') {
        projects.add(entry);
      }
    }

    projects.sort((entryA, entryB) {
      final DateTime dateCreatedA = entryA.value.finishDate!;
      final DateTime dateCreatedB = entryB.value.finishDate!;

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
          width: 850.0,
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
                      'Tus proyectos',
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
                              for (final MapEntry<int, Project> entry
                                  in projects)
                                ProjectCard(
                                  project: entry.value,
                                  setParentState: () => setState(() {}),
                                  onPressed: () => _editProject(
                                    context,
                                    entry.value,
                                  ),
                                  onTaskPresed: (Task task) => _editTask(
                                    context,
                                    task,
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
                    text: 'Agregar proyecto',
                    icon: Icons.add_box_outlined,
                    innerSize: cardElementFontSize,
                    onPressed: () => _createProject(context),
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
