import 'package:gtd_client/utilities/themes.dart';
import 'package:gtd_client/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.dark,
      home: const LoginScreen(),
    ),
  );
}
