import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/mixins/sign_in_screen_mixin.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/show_up_text.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/username.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with SignInScreenMixin {
  Future<void> _submitSignIn(BuildContext context) async {
    if (testNavigation) {
      context.go('/app');

      return;
    }

    final http.Response response = await http.post(
      Uri.parse('$serverUrl/auth/login'),
      headers: contentType,
      body: jsonEncode(
        <String, dynamic>{
          'username': username,
          'password': password,
        },
      ),
    );

    debugPrint('/auth/login call status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final String sessionToken = response.body;

      debugPrint('Session token: $sessionToken');

      const FlutterSecureStorage().write(
        key: 'session_token',
        value: sessionToken,
      );

      final http.Response userDataRespone = await http.get(
        Uri.parse('$serverUrl/userData/authed'),
        headers: {
          'Authorization': 'Bearer $sessionToken',
        }..addAll(contentType),
      );

      debugPrint(
        '/userData/authed call status code: ${userDataRespone.statusCode}',
      );

      ref.read(usernameProvider.notifier).set(username);
      ref.read(sessionTokenProvider.notifier).set(sessionToken);

      if (context.mounted) {
        switch (userDataRespone.statusCode) {
          case 200:
            ref.read(completedRegistryProvider.notifier).set(true);
            break;
          case 404:
            break;
          default:
            debugPrint('Reached default case');

            setState(() {
              errorMessage = 'Hubo un error inesperado';
              showError = true;
            });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: SignInScreenMixin.topSpacing),
            const Padding(
              padding: SignInScreenMixin.rowPadding,
              child: SignInScreenMixin.titleWidget,
            ),
            const Padding(
              padding: SignInScreenMixin.doublePadding,
              child: Text(
                'Inicio de sesión',
                style: TextStyle(fontSize: SignInScreenMixin.subtitleFontSize),
              ),
            ),
            SizedBox(
              width: SignInScreenMixin.formWidth,
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            hintText: 'tu usuario',
                            validator: validateUsername,
                            label: 'Nombre de usuario',
                            autofillHint: AutofillHints.username,
                          ),
                        ),
                        CustomFormField(
                          label: 'Contraseña',
                          hintText: 'tu contraseña',
                          validator: validatePassword,
                          autofillHint: AutofillHints.password,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: SignInScreenMixin.buttonPadding,
                    child: LoadingSolidButton(
                      text: 'Inicia sesión',
                      size: SignInScreenMixin.buttonSize,
                      textSize: SignInScreenMixin.buttonFontSize,
                      onPressed: (username != null) && (password != null)
                          ? () => _submitSignIn(context)
                          : null,
                    ),
                  ),
                  ShowUpText(
                    visible: showError,
                    text: errorMessage,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.error,
                      fontSize: SignInScreenMixin.errorFontSize,
                    ),
                  ),
                  Visibility(
                    visible: showError,
                    child: const SizedBox(height: paddingAmount),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Todavía no tienes cuenta? '),
                      TextButton(
                        onPressed: () => context.go('/sign_up'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: const Text('Regístrate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
