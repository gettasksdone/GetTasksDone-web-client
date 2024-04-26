import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

void showModal(
  BuildContext buildContext,
  WidgetRef ref,
  VoidCallback setParentState,
  Context? selectedContext,
) {
  final bool existingContext = selectedContext != null;
  final Context context = selectedContext ?? Context();
  final ColorScheme colors = buildContext.colorScheme;
  final UserData userData = UserData();

  Future<void> onGreenButton() async {
    if (existingContext) {
      await patchContext(
        ref,
        context,
        () {
          userData.putContext(context.id, context);

          if (buildContext.mounted) {
            buildContext.pop();

            setParentState();
          }
        },
      );

      return;
    }

    await postContext(
      ref,
      context,
      (int id) {
        context.setId(id);

        userData.putContext(context.id, context);

        if (buildContext.mounted) {
          buildContext.pop();

          setParentState();
        }
      },
    );
  }

  showDialog(
    context: buildContext,
    builder: (buildContext) {
      return StatefulBuilder(
        builder: (buildContext, dialogSetState) {
          return CustomModal(
            size: const Size(400.0, 250.0),
            titleWidget: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Contexto',
                style: TextStyle(
                  fontSize: 25.0,
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CustomFormField(
                    label: 'Nombre',
                    hintText: 'nombre',
                    initialValue: context.name,
                    validator: (String? input) => notEmptyValidator(
                      input,
                      () => dialogSetState(() {
                        context.name = input;
                      }),
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
                        text: existingContext ? 'Guardar' : 'Crear',
                        onPressed: context.name == null ? null : onGreenButton,
                      ),
                    ),
                    if (existingContext) const SizedBox(width: paddingAmount),
                    if (existingContext)
                      Expanded(
                        child: LoadingSolidButton(
                          color: Colors.red,
                          size: modalButtonSize,
                          textColor: Colors.white,
                          textSize: modalButtonFontSize,
                          text: 'Borrar',
                          onPressed: () async {
                            await deleteContext(
                              ref,
                              context.id,
                              () async {
                                userData.clear();
                                userData.loadUserData(
                                  ref,
                                  await getUserDataResponse(ref),
                                );

                                if (buildContext.mounted) {
                                  buildContext.pop();

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
