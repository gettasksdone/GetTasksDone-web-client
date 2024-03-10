import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/mixins/sign_in_screen_mixin.dart';
import 'package:gtd_client/widgets/account_form_field.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/widgets/show_up_text.dart';
import 'package:gtd_client/widgets/solid_button.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/account.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
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
  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        if (ref.watch(sessionTokenProvider) != null) {
          context.go('/app');
        }
      }
    });
  }

  void _submitSignIn(BuildContext context) async {
    if (kDebugMode) {
      if (context.mounted) {
        context.go('/app');
      }

      return;
    }

    final http.Response respone = await http.post(
      Uri.parse('$serverUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'username': account,
          'password': password,
        },
      ),
    );

    if (respone.statusCode == 200) {
      final String sessionToken = respone.body;

      const FlutterSecureStorage().write(
        key: 'session_token',
        value: sessionToken,
      );

      ref.read(sessionTokenProvider.notifier).set(sessionToken);
      ref.read(accountProvider.notifier).set(account);

      final http.Response userDataRespone = await http.post(
        Uri.parse('$serverUrl/userData'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $sessionToken',
        },
      );

      if (context.mounted) {
        if (userDataRespone.body.isEmpty) {
          context.go('/complete_registry');
        } else {
          ref.read(completedRegistryProvider.notifier).set(true);
          context.go('/app');
        }
      }

      return;
    }

    setState(() {
      errorMessage = 'Hubo un error inesperado';
      showError = true;
    });
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
                          child: AccountFormField(
                            hintText: 'tu usuario',
                            validator: validateUsername,
                            label: 'Nombre de usuario',
                            autofillHint: AutofillHints.username,
                          ),
                        ),
                        AccountFormField(
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
                    child: SolidButton(
                      text: 'Inicia sesión',
                      size: SignInScreenMixin.buttonSize,
                      textSize: SignInScreenMixin.buttonFontSize,
                      onPressed: (account != null) && (password != null)
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
