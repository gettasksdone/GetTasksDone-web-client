import 'package:gtd_client/widgets/custom_dropdown_menu.dart';
import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
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
) {
  final ColorScheme colors = context.colorScheme;
  final UserData userData = UserData();
  final Task task = Task();

  final TextStyle dropdownTextStyle = TextStyle(color: colors.onSecondary);

  Future<void> onCreate() async {
    await postTask(
      ref,
      task,
      userData.inboxId,
      (int id) {
        task.setId(id);

        userData.putTask(ref, task, userData.inboxId);

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
            size: Size(modalSize.width, 400.0),
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: CustomFormField(
                label: 'Nombre *',
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
                      label: 'Contexto *',
                      width: fullDropdownWidth,
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
                            labelWidget: Text(
                              entry.value.name!,
                              style: dropdownTextStyle,
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: context.theme.canvasColor,
                              fixedSize: Size(
                                fullDropdownWidth,
                                dropdownOptionHeight,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: LoadingSolidButton(
                        text: 'Crear',
                        color: Colors.green,
                        size: modalButtonSize,
                        textColor: Colors.white,
                        textSize: modalButtonFontSize,
                        onPressed: task.title == null || task.contextId == null
                            ? null
                            : onCreate,
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
