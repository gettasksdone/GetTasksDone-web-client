import 'package:gtd_client/utilities/constants.dart';
import 'package:flutter/material.dart';

mixin SignInScreenMixin<T extends StatefulWidget> on State<T> {
  static const EdgeInsets rowPadding = EdgeInsets.only(bottom: paddingAmount);
  static const EdgeInsets doublePadding = EdgeInsets.only(bottom: 20.0);
  static const Size buttonSize = Size(300.0, 60.0);
  static const double subtitleFontSize = 20.0;
  static const double buttonFontSize = 20.0;
  static const double errorFontSize = 18.0;
  static const double topSpacing = 200.0;
  static const double formWidth = 350.0;
  static const EdgeInsets buttonPadding = EdgeInsets.only(
    top: 35.0,
    bottom: 10.0,
  );
  static const Text titleWidget = Text(
    appName,
    style: TextStyle(
      fontSize: 38.0,
      fontWeight: FontWeight.bold,
    ),
  );

  final GlobalKey formKey = GlobalKey<FormState>();

  bool showError = false;
  String? errorMessage;
  String? password;
  String? username;

  String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Por favor introduzca usuario';
    }

    setState(() {
      this.username = username;
    });

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Introduzca contraseña';
    }

    setState(() {
      this.password = password;
    });

    return null;
  }
}
