import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class ProjectsView extends ConsumerStatefulWidget {
  const ProjectsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  final UserData _userData = UserData();

  @override
  void initState() {
    super.initState();
  }

  void _getProjects() async {
    final http.Response response = await http.get(
      Uri.parse('$serverUrl/project/authed'),
      headers: headers(ref),
    );

    debugPrint('/project/authed call status code: ${response.statusCode}');

    debugPrint(response.body);

    if (response.statusCode == 200) {
      for (final MapEntry<int, Project> entry
          in Project.instance.decodeList(response.body).entries) {
        debugPrint('Adding project with ID [${entry.key}]');

        _userData.addProject(entry.key, entry.value);
      }
    }
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
    return Center(
      child: TextButton(
        onPressed: _getProjects,
        child: const Text('Prueba'),
      ),
    );

    // return Center(
    //   child: SizedBox(
    //     height: 600.0,
    //     width: 350.0,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         Padding(
    //           padding: _rowPadding,
    //           child: Text(
    //             'Tus tareas',
    //             style: TextStyle(
    //               fontSize: 23.0,
    //               color: colors.onSecondary,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ),
    //         for (int i = 0; i < _tasks.length; i++)
    //           Padding(
    //             padding: _rowPadding,
    //             child: Row(
    //               children: [
    //                 Expanded(
    //                   child: CheckboxButton(
    //                     text: _tasks[i].name,
    //                     onChanged: (value) {},
    //                   ),
    //                 ),
    //                 const SizedBox(width: 10.0),
    //                 SizedBox(
    //                   width: _editButtonSize,
    //                   height: _editButtonSize,
    //                   child: IconButton(
    //                     icon: const Icon(Icons.edit),
    //                     style: IconButton.styleFrom(
    //                       backgroundColor: colors.onSurface.lighten(80),
    //                       shape: const RoundedRectangleBorder(
    //                         borderRadius: roundedCorners,
    //                       ),
    //                     ),
    //                     onPressed: () {
    //                       setState(() {
    //                         _editTaskIndex = i;
    //                         _editTask = true;
    //                       });
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         const SizedBox(height: 50.0),
    //         const CustomIconButton(
    //           label: 'Agregar tarea',
    //           icon: Icons.add_box_outlined,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
