import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
    if (testNavigation) {
      // TODO
      return;
    }

    final http.Response response = await http.post(
      Uri.parse('$serverUrl/project'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${ref.watch(sessionTokenProvider)}',
      },
    );

    debugPrint('/project (authed) call status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      for (final MapEntry<int, Project> entry
          in Project.instance.parseList(response.body).entries) {
        debugPrint('Adding project with ID [${entry.key}]');

        _userData.addProject(entry.key, entry.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getProjects();

    return const Placeholder();

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
