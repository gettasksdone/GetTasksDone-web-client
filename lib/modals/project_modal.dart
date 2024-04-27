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
import 'package:gtd_client/logic/project.dart';
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
  Project? selectedProject,
) {
  final ColorScheme colors = context.colorScheme;
  final bool existingProject = selectedProject != null;
  final Project project = selectedProject ?? Project();
  final UserData userData = UserData();

  final TextStyle dropdownTextStyle = TextStyle(color: colors.onPrimary);
  final ButtonStyle dropdownButtonStyle = TextButton.styleFrom(
    backgroundColor: context.theme.canvasColor,
  );

  Future<void> onGreenButton() async {
    if (existingProject) {
      await patchProject(
        ref,
        project,
        () {
          userData.putProject(project.id, project);

          if (context.mounted) {
            context.pop();

            setParentState();
          }
        },
      );

      return;
    }

    await postProject(
      ref,
      project,
      (int id) {
        project.setId(id);

        userData.putProject(id, project);

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

          return CustomModal(
            size: modalSize,
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: CustomFormField(
                label: 'Nombre',
                hintText: 'nombre',
                initialValue: project.name,
                validator: (String? input) => notEmptyValidator(
                  input,
                  () => dialogSetState(() {
                    project.name = input;
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
                      initialValue: project.description,
                      validator: (String? input) {
                        dialogSetState(() {
                          project.description = input;
                        });

                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: rowPadding,
                  child: SizedBox(
                    height: 45.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SolidButton(
                            text: project.startDate != null
                                ? 'Inicio ${project.startDate!.toCustomFormat}'
                                : 'Fecha de inicio',
                            onPressed: () async {
                              final DateTime? date = await showCustomDatePicker(
                                context: context,
                                finishDate:
                                    project.finishDate ?? DateTime.now(),
                              );

                              if (date != null) {
                                dialogSetState(() {
                                  project.setStart(date);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: paddingAmount),
                        Expanded(
                          child: SolidButton(
                            text: project.finishDate != null
                                ? 'Final ${project.finishDate!.toCustomFormat}'
                                : 'Fecha de finalización',
                            onPressed: () async {
                              final DateTime? date = await showCustomDatePicker(
                                context: context,
                                startDate: project.startDate ?? DateTime.now(),
                              );

                              if (date != null) {
                                dialogSetState(() {
                                  project.setFinish(date);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: rowPadding,
                  child: IntrinsicHeight(
                    child: CustomDropdownMenu(
                      label: 'Estado',
                      width: fullDropdownWidth,
                      initialSelection: project.state,
                      onSelected: (String? state) {
                        if (state != null) {
                          dialogSetState(() {
                            project.state = state;
                          });
                        }
                      },
                      entries: Project.selectableStates
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
                          .toList(),
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
                        text: existingProject ? 'Guardar' : 'Crear',
                        onPressed: project.name == null ? null : onGreenButton,
                      ),
                    ),
                    if (existingProject) const SizedBox(width: paddingAmount),
                    if (existingProject)
                      Expanded(
                        child: LoadingSolidButton(
                          color: Colors.red,
                          size: modalButtonSize,
                          textColor: Colors.white,
                          textSize: modalButtonFontSize,
                          text: 'Borrar',
                          onPressed: () async {
                            // TODO: Error del servidor
                            await deleteProject(
                              ref,
                              project.id,
                              () {
                                userData.removeProject(project.id);

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
