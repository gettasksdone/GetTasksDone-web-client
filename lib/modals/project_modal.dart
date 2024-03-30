import 'package:gtd_client/modals/custom_date_picker.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/custom_tag_row.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:flutter/material.dart';

void showModal(
  BuildContext context,
  String buttonText,
  Project? selectedProject,
) {
  final TextStyle titleStyle = TextStyle(
    fontSize: elementCardFontSize,
    color: context.colorScheme.onSecondary,
    fontWeight: FontWeight.w600,
  );
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
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: modalFieldsFlex,
                      child: CustomFormField(
                        label: 'Nombre',
                        hintText: 'nombre',
                        initialValue: name,
                        validator: (String? input) => notEmptyValidator(
                          input,
                          'Introduzca nombre del proyecto',
                          () => dialogSetState(() {
                            name = input!;
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingAmount),
                    Expanded(
                      flex: modalRightFlex,
                      child: Center(
                        child: Text(
                          'Notas',
                          style: titleStyle,
                        ),
                      ),
                    ),
                    const SizedBox(width: paddingAmount),
                    Expanded(
                      flex: modalRightFlex,
                      child: Center(
                        child: Text(
                          'Tareas',
                          style: titleStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bodyWidget: Row(
              children: [
                Expanded(
                  flex: modalFieldsFlex,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: rowPadding,
                        child: CustomTagRow(
                          tags: tags,
                          onTagAdded: (int? id) {
                            if (id != null) {
                              dialogSetState(
                                () {
                                  tags.add(id);
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: rowPadding,
                        child: CustomFormField(
                          label: 'Estado',
                          hintText: 'estado',
                          initialValue: state,
                          validator: (String? input) => notEmptyValidator(
                            input,
                            'Introduzca estado del proyecto',
                            () => dialogSetState(() {
                              state = input!;
                            }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: rowPadding,
                          child: CustomFormField(
                            multiline: true,
                            label: 'Descripción',
                            hintText: 'descripción',
                            initialValue: description,
                            validator: (String? input) => notEmptyValidator(
                              input,
                              'Introduzca descripción del proyecto',
                              () => dialogSetState(() {
                                description = input!;
                              }),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: rowPadding,
                        child: Row(
                          children: [
                            Expanded(
                              child: SolidButton(
                                size: modalButtonSize,
                                text: 'Inicio $parsedStartDate',
                                onPressed: () async {
                                  final DateTime? result =
                                      await showCustomDatePicker(
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
                                size: modalButtonSize,
                                text: 'Final $parsedEndDate',
                                onPressed: () async {
                                  final DateTime? result =
                                      await showCustomDatePicker(
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
                      SolidButton(
                        color: Colors.green,
                        size: modalButtonSize,
                        withWidget: Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: paddingAmount),
                const Expanded(
                  flex: modalRightFlex,
                  child: Placeholder(),
                ),
                const SizedBox(width: paddingAmount),
                const Expanded(
                  flex: modalRightFlex,
                  child: Placeholder(),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
