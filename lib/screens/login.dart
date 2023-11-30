import 'package:gtd_client/widgets/clear_icon_button.dart';
import 'package:gtd_client/widgets/gradient_button.dart';
import 'package:gtd_client/widgets/login_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 170),
              const Text(
                'FdI Getting Things Done',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                child: Column(
                  children: [
                    const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClearIconButton(
                      text: 'Continue with Google',
                      onPressed: () {},
                      height: 60,
                      svgName: 'google_logo',
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'or',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 10),
                    const LoginField(
                      hint: 'email',
                      autofillHint: [AutofillHints.username],
                    ),
                    const SizedBox(height: 10),
                    const LoginField(
                      hint: 'password',
                      autofillHint: [AutofillHints.password],
                    ),
                    const SizedBox(height: 30),
                    GradientButton(
                      text: 'Sign in',
                      onPressed: () {},
                      height: 60,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not registered? ',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            padding: const EdgeInsets.all(5),
                          ),
                          child: const Text(
                            'Create account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
