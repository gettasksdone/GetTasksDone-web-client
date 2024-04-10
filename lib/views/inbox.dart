import 'package:gtd_client/widgets/custom_progress_indicator.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/widgets/card_element.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/modals/task_modal.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class InboxView extends ConsumerStatefulWidget {
  const InboxView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InboxViewState();
}

class _InboxViewState extends ConsumerState<InboxView> {
  static final UserData _userData = UserData();

  Future<Project> _getInboxProject() async {
    final http.Response response = await http.get(
      Uri.parse('$serverUrl/project/authed'),
      headers: headers(ref),
    );

    debugPrint('/project/authed call status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      _userData.decodeProjects(response.body);
    }

    return _userData.getInboxProject();
  }

  void _editTask(BuildContext context, Task task) {
    showModal(context, ref, task);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Center(
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
                    child: FutureBuilder(
                      future: _getInboxProject(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<MapEntry<int, Task>> tasks = [];

                          for (final int id in snapshot.data!.tasks) {
                            final Task task = _userData.getTask(id);

                            if (task.expiration == null) {
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

                          return Padding(
                            padding: cardPadding,
                            child: ListView(
                              children: [
                                for (final MapEntry<int, Task> entry in tasks)
                                  CardElement(
                                    cells: [
                                      CardCellData(
                                        icon: Icons.folder,
                                        text: entry.value.description!
                                            .split('|')[0],
                                      ),
                                      CardCellData(
                                        width: 150.0,
                                        icon: Icons.push_pin,
                                        text: entry.value.state!,
                                      ),
                                      CardCellData(
                                        icon: Icons.calendar_today,
                                        text:
                                            entry.value.created.toCustomFormat,
                                      ),
                                    ],
                                    onPressed: () => _editTask(
                                      context,
                                      entry.value,
                                    ),
                                  ),
                                SolidIconButton(
                                  center: true,
                                  size: cardElementSize,
                                  text: 'Agregar proyecto',
                                  icon: Icons.add_box_outlined,
                                  innerSize: cardElementFontSize,
                                  onPressed: () {},
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
