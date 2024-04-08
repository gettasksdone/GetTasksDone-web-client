import 'package:gtd_client/modals/custom_date_picker.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:flutter/material.dart';

void showModal(BuildContext context, Task? selectedTask) {
  final ColorScheme colors = context.colorScheme;
  final bool existingTask = selectedTask != null;
  final Task task = selectedTask ?? Task();

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
                            items: UserData().contexts.entries.map(
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
                      child: SolidButton(
                        color: Colors.green,
                        size: modalButtonSize,
                        withWidget: Text(
                          existingTask ? 'Guardar' : 'Crear',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: modalButtonFontSize,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    if (existingTask) const SizedBox(width: paddingAmount),
                    if (existingTask)
                      Expanded(
                        child: SolidButton(
                          color: Colors.red,
                          size: modalButtonSize,
                          withWidget: const Text(
                            'Borrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: modalButtonFontSize,
                            ),
                          ),
                          onPressed: () {},
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
