import 'package:gtd_client/widgets/custom_dropdown_menu.dart';
import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/modals/custom_date_picker.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Supposed to be patched by Flutter
const double _totalCardPadding = 2.0 * cardPaddingAmount;
const double _totalPaddingAmount = 2.0 * paddingAmount;

void showModal(
  BuildContext context,
  WidgetRef ref,
  VoidCallback setParentState,
  Task? selectedTask,
) {
  final ColorScheme colors = context.colorScheme;
  final bool existingTask = selectedTask != null;
  final Task task = selectedTask ?? Task();
  final UserData userData = UserData();

  final TextStyle dropdownTextStyle = TextStyle(color: colors.onPrimary);
  final ButtonStyle dropdownButtonStyle = TextButton.styleFrom(
    backgroundColor: context.theme.canvasColor,
  );

  int projectId =
      existingTask ? userData.getProjectIdOfTask(task.id) : userData.inboxId;

  Future<void> onGreenButton() async {
    if (existingTask) {
      await patchTask(
        ref,
        task,
        projectId,
        () {
          userData.putTask(ref, task, projectId);

          if (context.mounted) {
            context.pop();

            setParentState();
          }
        },
      );

      return;
    }

    await postTask(
      ref,
      task,
      projectId,
      (int id) {
        task.setId(id);

        userData.getProject(projectId).addTask(task.id);

        userData.putTask(ref, task, projectId);

        if (context.mounted) {
          context.pop();

          setParentState();
        }
      },
    );
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, dialogSetState) {
          // Supposed to be patched by Flutter
          final double fullDropdownWidth =
              context.parentSize.width < modalSize.width
                  ? context.parentSize.width -
                      _totalCardPadding -
                      _totalPaddingAmount
                  : modalSize.width - _totalCardPadding;
          final double dropdownWidth =
              (fullDropdownWidth - paddingAmount) * 0.5;

          return CustomModal(
            size: modalSize,
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: CustomFormField(
                label: 'Nombre',
                hintText: 'nombre',
                initialValue: task.title,
                validator: (String? input) => notEmptyValidator(
                  input,
                  () => dialogSetState(() {
                    task.title = input;
                  }),
                ),
              ),
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: rowPadding,
                    child: CustomFormField(
                      expands: true,
                      label: 'Descripción',
                      hintText: 'descripción',
                      initialValue: task.description,
                      validator: (String? input) {
                        dialogSetState(() {
                          task.description = input;
                        });

                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: rowPadding,
                  child: IntrinsicHeight(
                    child: CustomDropdownMenu(
                      label: 'Estado',
                      width: fullDropdownWidth,
                      initialSelection: task.state,
                      onSelected: (String? state) {
                        if (state != null) {
                          dialogSetState(() {
                            task.state = state;
                          });
                        }
                      },
                      entries: Task.selectableStates
                          .map(
                            (entry) => DropdownMenuEntry<String>(
                              value: entry,
                              label: entry,
                              style: dropdownButtonStyle,
                              labelWidget: Text(
                                entry,
                                style: dropdownTextStyle,
                              ),
                            ),
                          )
                          .toList()
                        ..addAll(task.state == Task.done
                            ? [
                                DropdownMenuEntry<String>(
                                  value: Task.done,
                                  label: Task.done,
                                  style: dropdownButtonStyle,
                                  labelWidget: Text(
                                    Task.done,
                                    style: dropdownTextStyle,
                                  ),
                                ),
                              ]
                            : []),
                    ),
                  ),
                ),
                Padding(
                  padding: rowPadding,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomDropdownMenu(
                          label: 'Proyecto',
                          width: dropdownWidth,
                          initialSelection: projectId,
                          onSelected: (int? id) {
                            if (id != null) {
                              dialogSetState(() {
                                projectId = id;
                              });
                            }
                          },
                          entries: userData.projects.entries.map(
                            (entry) {
                              final String label = entry.key != userData.inboxId
                                  ? entry.value.name!
                                  : 'Ninguno';

                              return DropdownMenuEntry<int>(
                                label: label,
                                value: entry.key,
                                style: dropdownButtonStyle,
                                labelWidget: Text(
                                  label,
                                  style: dropdownTextStyle,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        const SizedBox(width: paddingAmount),
                        CustomDropdownMenu(
                          label: 'Contexto',
                          width: dropdownWidth,
                          initialSelection: task.contextId,
                          onSelected: (int? id) {
                            dialogSetState(() {
                              task.contextId = id;
                            });
                          },
                          entries: userData.contexts.entries.map(
                            (entry) {
                              return DropdownMenuEntry<int>(
                                value: entry.key,
                                label: entry.value.name!,
                                style: dropdownButtonStyle,
                                labelWidget: Text(
                                  entry.value.name!,
                                  style: dropdownTextStyle,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.secondary,
                              borderRadius: roundedCorners,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: paddingAmount,
                                vertical: paddingAmount / 2.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                      child: Text(
                                    'Importante',
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  Switch(
                                    value: task.priority != 0,
                                    onChanged: (bool value) {
                                      dialogSetState(() {
                                        if (value) {
                                          task.priority = 1;
                                        } else {
                                          task.priority = 0;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: paddingAmount),
                        Expanded(
                          child: SolidButton(
                            text: task.expiration != null
                                ? 'Expiración ${task.expiration!.toCustomFormat}'
                                : 'Fecha de expiración',
                            onPressed: () async {
                              final DateTime? date = await showCustomDatePicker(
                                context: context,
                                startDate: task.created,
                              );

                              dialogSetState(() {
                                task.setExpiration(date);
                              });
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
                        onPressed: task.title == null || task.contextId == null
                            ? null
                            : onGreenButton,
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
                            await deleteTask(
                              ref,
                              task.id,
                              () {
                                userData.removeTask(ref, task.id);

                                if (context.mounted) {
                                  context.pop();

                                  setParentState();
                                }
                              },
                            );
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
