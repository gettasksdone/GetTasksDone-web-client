import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/mixins/sign_in_screen_mixin.dart';
import 'package:gtd_client/widgets/custom_form_field.dart';
import 'package:gtd_client/widgets/backend_url_field.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/show_up_text.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/username.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with SignInScreenMixin {
  bool _matchingPasswords = false;
  String? _email;

  Future<void> _submitSingUp(BuildContext context) async {
    if (testNavigation) {
      context.go('/complete_registry');

      return;
    }

    final http.Response response = await postAuthRegister(
      username!,
      password!,
      _email!,
    );

    if (response.statusCode == 200) {
      debugPrint('Session token: ${response.body}');

      const FlutterSecureStorage().write(
        key: 'session_token',
        value: response.body,
      );

      ref.read(usernameProvider.notifier).set(username);
      ref.read(sessionTokenProvider.notifier).set(response.body);

      return;
    }

    setState(() {
      errorMessage = response.body;
      showError = true;
    });
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Por favor introduzca correo electrónico';
    }

    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email)) {
      return 'Introduzca un correo electrónico válido';
    }

    setState(() {
      _email = email;
    });

    return null;
  }

  String? _validateRepeatPassword(String? password) {
    if (password == null || password.isEmpty) {
      if (_matchingPasswords) {
        setState(() {
          _matchingPasswords = false;
        });
      }

      return 'Introduzca contraseña de nuevo';
    }

    setState(() {
      _matchingPasswords = this.password == password;
    });

    if (!_matchingPasswords) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: SignInScreenMixin.rowPadding,
              child: SignInScreenMixin.titleWidget,
            ),
            const Padding(
              padding: SignInScreenMixin.doublePadding,
              child: Text(
                'Registro',
                style: TextStyle(
                  fontSize: SignInScreenMixin.subtitleFontSize,
                ),
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
                        const Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: BackendUrlField(),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            hintText: 'tu usuario',
                            validator: validateUsername,
                            label: 'Nombre de usuario',
                            autofillHint: AutofillHints.username,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            validator: _validateEmail,
                            label: 'Correo electrónico',
                            hintText: 'tu@correo.electrónico',
                            autofillHint: AutofillHints.email,
                          ),
                        ),
                        Padding(
                          padding: SignInScreenMixin.doublePadding,
                          child: CustomFormField(
                            label: 'Contraseña',
                            hintText: 'tu contraseña',
                            validator: validatePassword,
                            autofillHint: AutofillHints.password,
                          ),
                        ),
                        CustomFormField(
                          label: 'Repetir contraseña',
                          hintText: 'repite tu contraseña',
                          validator: _validateRepeatPassword,
                          autofillHint: AutofillHints.password,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: SignInScreenMixin.buttonPadding,
                    child: LoadingSolidButton(
                      text: 'Registrarse',
                      size: SignInScreenMixin.buttonSize,
                      textSize: SignInScreenMixin.buttonFontSize,
                      onPressed: (username != null) &&
                              (_email != null) &&
                              _matchingPasswords
                          ? () => _submitSingUp(context)
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
                      const Text('¿Tienes cuenta? '),
                      TextButton(
                        onPressed: () => context.go('/sign_in'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: const Text('Inicia sesión'),
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
