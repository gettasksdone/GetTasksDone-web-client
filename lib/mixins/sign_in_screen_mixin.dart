import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

mixin SignInScreenMixin<T extends StatefulWidget> on State<T> {
  static const double messageFontSize = 17.0;

  final GlobalKey formKey = GlobalKey<FormState>();

  String? errorMessage;
  String? password;
  String? account;

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter an email';
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return 'Please enter a valid email';
    }

    setState(() {
      account = email;
    });

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter password';
    }

    setState(() {
      this.password = sha256.convert(utf8.encode(password)).toString();
    });

    return null;
  }
}