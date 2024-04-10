import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/modals/custom_date_picker.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void showModal(BuildContext context, WidgetRef ref, Task? selectedTask) {
  final ColorScheme colors = context.colorScheme;
  final bool existingTask = selectedTask != null;
  final Task task = selectedTask ?? Task();
  final UserData userData = UserData();

  final String? taskDescription = task.description;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, dialogSetState) {
          String? description;
          String? name;

          if (taskDescription != null) {
            final List<String> parts = taskDescription.split('|');

            description = parts[1];
            name = parts[0];
          }

          return CustomModal(
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: CustomFormField(
                label: 'Nombre',
                hintText: 'nombre',
                initialValue: name,
                validator: (String? input) => notEmptyValidator(
                  input,
                  () => dialogSetState(() {
                    name = input;
                  }),
                ),
              ),
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: rowPadding,
                  child: CustomFormField(
                    multiline: true,
                    label: 'Descripción',
                    hintText: 'descripción',
                    initialValue: description,
                    validator: (String? input) => notEmptyValidator(
                      input,
                      () => dialogSetState(() {
                        description = input;
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: rowPadding,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            menuMaxHeight: 400.0,
                            value: task.contextId,
                            style: TextStyle(color: colors.onTertiary),
                            decoration: InputDecoration(
                              labelText: 'Contexto',
                              labelStyle: TextStyle(
                                color: colors.onTertiary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: roundedCorners,
                                borderSide: BorderSide(
                                  width: edgeWidth,
                                  color: colors.primary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: roundedCorners,
                                borderSide: BorderSide(
                                  width: edgeWidth,
                                  color: colors.primary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: roundedCorners,
                                borderSide: BorderSide(
                                  width: edgeWidth,
                                  color: colors.primary.darken(20),
                                ),
                              ),
                            ),
                            onChanged: (int? id) {
                              if (id != null) {
                                dialogSetState(() {
                                  task.contextId = id;
                                });
                              }
                            },
                            items: userData.contexts.entries.map(
                              (entry) {
                                return DropdownMenuItem<int>(
                                  value: entry.key,
                                  child: Text(entry.value.name!),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const SizedBox(width: paddingAmount),
                        Expanded(
                          child: SolidButton(
                            size: modalButtonSize,
                            text: existingTask
                                ? 'Expiración ${task.expiration!.toCustomFormat}'
                                : 'Fecha de expiración',
                            onPressed: () async {
                              final DateTime? date = await showCustomDatePicker(
                                context: context,
                                startDate: task.created,
                              );

                              if (date != null) {
                                dialogSetState(() {
                                  task.setExpiration(date);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: LoadingSolidButton(
                        color: Colors.green,
                        size: modalButtonSize,
                        textColor: Colors.white,
                        textSize: modalButtonFontSize,
                        text: existingTask ? 'Guardar' : 'Crear',
                        onPressed: () async {
                          task.description = '$name|$description';

                          final String requestBody = jsonEncode(task.toJson());
                          final Map<String, String> requestHeaders = headers(
                            ref,
                          );

                          final http.Response response;
                          final String url;

                          if (existingTask) {
                            url = '$serverUrl/task/update/${task.id}';

                            response = await http.patch(
                              Uri.parse(url),
                              headers: requestHeaders,
                              body: requestBody,
                            );
                          } else {
                            url =
                                '$serverUrl/task/create?ProjectID=${userData.inboxId}';

                            response = await http.post(
                              Uri.parse(url),
                              headers: requestHeaders,
                              body: requestBody,
                            );
                          }

                          debugPrint(
                              '$url call status code: ${response.statusCode}');

                          if (response.statusCode == 200) {
                            if (!existingTask) {
                              task.setId(int.parse(response.body));

                              userData.getInboxProject().tasks.add(task.id);
                            }

                            userData.putTask(task.id, task);
                          }
                        },
                      ),
                    ),
                    if (existingTask) const SizedBox(width: paddingAmount),
                    if (existingTask)
                      Expanded(
                        child: LoadingSolidButton(
                          color: Colors.red,
                          size: modalButtonSize,
                          textColor: Colors.white,
                          textSize: modalButtonFontSize,
                          text: 'Borrar',
                          onPressed: () async {
                            final http.Response response = await http.delete(
                              Uri.parse('$serverUrl/task/delete/${task.id}'),
                              headers: headers(ref),
                              body: jsonEncode(task.toJson()),
                            );

                            debugPrint(
                                '/task/delete/${task.id} call status code: ${response.statusCode}');

                            if (response.statusCode == 200) {
                              userData.getInboxProject().tasks.remove(task.id);
                              userData.removeTask(task.id);
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
