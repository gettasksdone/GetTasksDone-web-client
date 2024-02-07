import 'package:blackforesttools/widgets/account_form_field.dart';
import 'package:blackforesttools/mixins/login_screen_mixin.dart';
import 'package:blackforesttools/widgets/gradient_button.dart';
import 'package:blackforesttools/providers/session_token.dart';
import 'package:blackforesttools/widgets/custom_app_bar.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/widgets/show_up_text.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:blackforesttools/providers/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    with LoginScreenMixin {
  void _submitLogin(BuildContext context) async {
    if (kDebugMode) {
      ref.read(sessionTokenProvider.notifier).set('session_token');
      ref.read(accountProvider.notifier).set('account@account.acc');

      if (context.mounted) {
        context.go('/app');
      }

      return;
    }

    final http.Response respone = await http.post(
      Uri.parse('$serverUrl/sign_in'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'account': account,
          'password': password,
        },
      ),
    );

    final Map<String, dynamic> payload = jsonDecode(respone.body);

    if (respone.statusCode == 200) {
      ref.read(sessionTokenProvider.notifier).set(payload['session_token']);
      ref.read(accountProvider.notifier).set(account);

      if (context.mounted) {
        context.go('/app');
      }

      return;
    }

    setState(() {
      errorMessage = payload['message'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showError = errorMessage != null;

    return Scaffold(
      appBar: const CustomAppBar(implyLeading: false),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            const Text(
              'Black Forest Tools',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 350.0,
              child: Column(
                children: [
                  const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AccountFormField(
                          hintText: 'email',
                          validator: validateEmail,
                          autofillHint: AutofillHints.username,
                        ),
                        const SizedBox(height: 10.0),
                        AccountFormField(
                          hintText: 'password',
                          validator: validatePassword,
                          autofillHint: AutofillHints.password,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  GradientButton(
                    height: 60.0,
                    buttonText: 'Sign in',
                    lightenGradient: true,
                    onPressed: (account != null) && (password != null)
                        ? () => _submitLogin(context)
                        : null,
                  ),
                  const SizedBox(height: 10.0),
                  ShowUpText(
                    visible: showError,
                    text: errorMessage,
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.error,
                    ),
                  ),
                  Visibility(
                    visible: showError,
                    child: const SizedBox(height: 10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not registered? ',
                        style: TextStyle(
                          fontSize: LoginScreenMixin.messageFontSize,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                        ),
                        child: const Text(
                          'Create account',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: LoginScreenMixin.messageFontSize,
                          ),
                        ),
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
