import 'package:gtdclient/config/config.dart';
import 'package:gtdclient/screens/home.dart';
import 'package:flutter/material.dart';

class GTDApp extends StatelessWidget {
  const GTDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.espresso,
      home: const HomeScreen(),
    );
  }
}
