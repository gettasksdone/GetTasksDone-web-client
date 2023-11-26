import 'package:gtd_client/widgets/google_signin.dart';
import 'package:gtd_client/utilities/extensions.dart';
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
      appBar: AppBar(
        backgroundColor: context.colorScheme.primary,
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              children: [
                SizedBox(height: 200),
                Text(
                  "Sign in",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                SizedBox(height: 20),
                GoogleSignIn(),
                SizedBox(height: 10),
                Text(
                  "or",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 10),
                LoginField(hint: "email"),
                SizedBox(height: 10),
                LoginField(
                  hint: "password",
                  obscure: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
