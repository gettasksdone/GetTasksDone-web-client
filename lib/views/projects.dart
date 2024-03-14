import 'package:gtd_client/widgets/custom_progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

class ProjectsView extends ConsumerStatefulWidget {
  const ProjectsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  final UserData _userData = UserData();

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

        _userData.addProject(entry.key, entry.value);
      }
    }

    return _userData.projects;
  }

  void _editProject(BuildContext context, MapEntry<int, Project> entry) {
    final ColorScheme colors = context.colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: roundedCorners),
          backgroundColor: colors.secondary,
          surfaceTintColor: Colors.transparent,
          child: SizedBox(
            width: modalSize.width,
            height: modalSize.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: modalHeaderHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: const BorderRadius.vertical(
                        top: cornerRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (final entry in projects.entries)
                                    Padding(
                                      padding: rowPadding,
                                      child: SolidButton(
                                        leftAligned: true,
                                        size: elementCardSize,
                                        onPressed: () =>
                                            _editProject(context, entry),
                                        color: Colors.primaries[Random()
                                            .nextInt(Colors.primaries.length)],
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
