import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/validators.dart';
import 'package:gtd_client/widgets/custom_modal.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void showModal(
  BuildContext buildContext,
  WidgetRef ref,
  VoidCallback callback,
  Context? selectedContext,
) {
  final bool existingContext = selectedContext != null;
  final Context context = selectedContext ?? Context();
  final ColorScheme colors = buildContext.colorScheme;
  final UserData userData = UserData();

  Future<void> onGreenButton() async {
    final String requestBody = jsonEncode(context.toJson());
    final Map<String, String> requestHeaders = headers(
      ref,
    );

    final http.Response response;
    final String url;

    if (existingContext) {
      url = '$serverUrl/context/update/${context.id}';

      response = await http.patch(
        Uri.parse(url),
        headers: requestHeaders,
        body: requestBody,
      );
    } else {
      url = '$serverUrl/context/createContext';

      response = await http.post(
        Uri.parse(url),
        headers: requestHeaders,
        body: requestBody,
      );
    }

    debugPrint('$url call status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      if (!existingContext) {
        context.setId(int.parse(response.body));
      }

      userData.putContext(context.id, context);

      if (buildContext.mounted) {
        buildContext.pop();

        callback();
      }
    }
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
                            final http.Response response = await http.delete(
                              Uri.parse(
                                  '$serverUrl/context/delete/${context.id}'),
                              headers: headers(ref),
                              body: jsonEncode(context.toJson()),
                            );

                            debugPrint(
                                '/context/delete/${context.id} call status code: ${response.statusCode}');

                            if (response.statusCode == 200) {
                              // TODO: Do not delete if used
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
