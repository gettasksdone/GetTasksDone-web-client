import 'package:blackforesttools/widgets/account_form_field.dart';
import 'package:blackforesttools/mixins/login_screen_mixin.dart';
import 'package:blackforesttools/widgets/gradient_button.dart';
import 'package:blackforesttools/widgets/custom_app_bar.dart';
import 'package:blackforesttools/widgets/show_up_text.dart';
import 'package:blackforesttools/utilities/extensions.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:async';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with LoginScreenMixin {
  bool _passwordsMatch = false;
  bool _signUpSuccess = false;

  void _submitSignUp(BuildContext context) async {
    if (kDebugMode) {
      setState(() {
        _signUpSuccess = true;
      });

      if (context.mounted) {
        context.go('/');
      }

      return;
    }

    final http.Response respone = await http.post(
      Uri.parse('$serverUrl/sign_up'),
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

    if (respone.statusCode == 200) {
      setState(() {
        _signUpSuccess = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          context.go('/');
        }
      });

      return;
    }

    setState(() {
      errorMessage =
          (jsonDecode(respone.body) as Map<String, dynamic>)['message'];
    });
  }

  String? _validateRepeatPassword(String? repeatPassword) {
    if ((repeatPassword == null || repeatPassword.isEmpty) ||
        (password == null || password!.isEmpty)) {
      setState(() {
        _passwordsMatch = false;
      });

      return 'Please enter password again';
    }

    bool match =
        sha256.convert(utf8.encode(repeatPassword)).toString() == password;

    setState(() {
      _passwordsMatch = match;
    });

    if (!match) {
      return 'Passwords do not match';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                    'Sign up',
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
                        const SizedBox(height: 10.0),
                        AccountFormField(
                          hintText: 'repeat password',
                          validator: _validateRepeatPassword,
                          autofillHint: AutofillHints.password,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  GradientButton(
                    height: 60.0,
                    lightenGradient: true,
                    buttonText: 'Register',
                    onPressed:
                        !_signUpSuccess && (account != null) && _passwordsMatch
                            ? () => _submitSignUp(context)
                            : null,
                  ),
                  const SizedBox(height: 10.0),
                  ShowUpText(
                    visible: _signUpSuccess,
                    text: 'Registered, going back to Login',
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: LoginScreenMixin.messageFontSize,
                    ),
                  ),
                  ShowUpText(
                    text: errorMessage,
                    visible: !_signUpSuccess && (errorMessage != null),
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.error,
                      fontSize: LoginScreenMixin.messageFontSize,
                    ),
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
