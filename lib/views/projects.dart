import 'package:gtd_client/widgets/custom_progress_indicator.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/mixins/app_screen_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class ProjectsView extends ConsumerStatefulWidget {
  const ProjectsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView>
    with AppScreenMixin {
  Future<Map<int, Project>> _getProjects() async {
    final http.Response response = await http.get(
      Uri.parse('$serverUrl/project/authed'),
      headers: headers(ref),
    );

    debugPrint('/project/authed call status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      for (final MapEntry<int, Project> entry
          in Project.instance.decodeList(response.body).entries) {
        debugPrint('Adding project with ID [${entry.key}]');

        userData.addProject(entry.key, entry.value);
      }
    }

    return userData.projects;
  }

  void _showProjectModal(BuildContext context, Project? selectedProject) {
    final List<int>? tasks;
    final List<int>? notes;
    final List<int> tags;

    String? description;
    DateTime finishDate;
    DateTime startDate;
    String? state;
    String? name;

    if (selectedProject != null) {
      description = selectedProject.description;
      finishDate = selectedProject.finishDate;
      startDate = selectedProject.startDate;
      state = selectedProject.state;
      tasks = selectedProject.tasks;
      notes = selectedProject.notes;
      name = selectedProject.name;
      tags = selectedProject.tags;
    } else {
      final DateTime currentTime = DateTime.now();

      finishDate = currentTime;
      startDate = currentTime;
      tags = [];
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            final String parsedStartDate = startDate.toCustomFormat;
            final String parsedEndDate = finishDate.toCustomFormat;

            return CustomModal(
              titleWidget: CustomFormField(
                label: 'Nombre',
                hintText: 'nombre',
                initialValue: name,
                validator: (String? input) {
                  final String? message = notEmptyValidator(
                    input,
                    'Introduzca nombre del proyecto',
                  );

                  if (message != null) {
                    return message;
                  }

                  dialogSetState(() {
                    name = input!;
                  });

                  return null;
                },
              ),
              bodyWidgets: [
                Padding(
                  padding: rowPadding,
                  child: getTagsWidget(context, tags, (int? id) {
                    if (id != null) {
                      dialogSetState(
                        () {
                          tags.add(id);
                        },
                      );
                    }
                  }),
                ),
                Padding(
                  padding: rowPadding,
                  child: CustomFormField(
                    multiline: true,
                    label: 'Descripción',
                    hintText: 'descripción',
                    initialValue: description,
                    validator: (String? input) {
                      final String? message = notEmptyValidator(
                        input,
                        'Introduzca descripción del proyecto',
                      );

                      if (message != null) {
                        return message;
                      } else {
                        dialogSetState(() {
                          description = input!;
                        });
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: rowPadding,
                  child: CustomFormField(
                    label: 'Estado',
                    hintText: 'estado',
                    initialValue: state,
                    validator: (String? input) {
                      final String? message = notEmptyValidator(
                        input,
                        'Introduzca estado del proyecto',
                      );

                      if (message != null) {
                        return message;
                      } else {
                        dialogSetState(() {
                          state = input!;
                        });
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: rowPadding,
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SolidButton(
                            text: 'Fecha de inicio [$parsedStartDate]',
                            onPressed: () async {
                              final DateTime? result = await showDateTimePicker(
                                context: context,
                                finishDate: finishDate,
                              );

                              if (result != null) {
                                dialogSetState(() {
                                  startDate = result;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: paddingAmount),
                        Expanded(
                          child: SolidButton(
                            text: 'Fecha de finalización [$parsedEndDate]',
                            onPressed: () async {
                              final DateTime? result = await showDateTimePicker(
                                context: context,
                                startDate: startDate,
                              );

                              if (result != null) {
                                dialogSetState(() {
                                  finishDate = result;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editProject(BuildContext context, MapEntry<int, Project> entry) {
    _showProjectModal(context, entry.value);
  }

  void _createProject(Project project) async {
    final http.Response response = await http.post(
      Uri.parse('$serverUrl/project/create'),
      headers: headers(ref),
      body: jsonEncode(project.toJson()),
    );

    debugPrint('/project/create call status code: ${response.statusCode}');
  }

  void _deleteProject(int id) async {
    final String endpoint = '/project/delete/$id';

    final http.Response response = await http.delete(
      Uri.parse('$serverUrl$endpoint'),
      headers: headers(ref),
    );

    debugPrint('$endpoint call status code: ${response.statusCode}');
  }

  void _updateProject(int id) async {
    // TODO
  }

  void _addTag(int projectId, int tagId) {
    // TODO
  }

  void _deleteTag(int projectId, int tagId) {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Center(
      child: SizedBox(
        width: 380.0,
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.tertiary,
                      borderRadius: roundedCorners,
                    ),
                    child: FutureBuilder(
                      future: _getProjects(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final Map<int, Project> projects = snapshot.data!;

                          return Padding(
                            padding: cardPadding,
                            child: ListView(
                              children: [
                                for (final entry in projects.entries)
                                  Padding(
                                    padding: rowPadding,
                                    child: SolidButton(
                                      leftAligned: true,
                                      size: elementCardSize,
                                      onPressed: () =>
                                          _editProject(context, entry),
                                      color: getRandomColor(),
                                      withWidget: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          entry.value.name,
                                          style: TextStyle(
                                            color: colors.onPrimary,
                                            fontSize: elementCardFontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SolidIconButton(
                                  onPressed: () {},
                                  size: elementCardSize,
                                  text: 'Agregar proyecto',
                                  icon: Icons.add_box_outlined,
                                  innerSize: elementCardFontSize,
                                ),
                              ],
                            ),
                          );
                        }

                        return const Center(child: CustomProgressIndicator());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
