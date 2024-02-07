import 'package:blackforesttools/utilities/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blackforesttools/screens/sign_up.dart';
import 'package:blackforesttools/screens/sign_in.dart';
import 'package:blackforesttools/screens/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInScreen(),
      routes: [
        GoRoute(
          path: 'register',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignUpScreen()),
        ),
        GoRoute(
          path: 'app',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AppScreen()),
        )
      ],
    ),
  ],
);

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        title: 'Black Forest Tools',
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    ),
  );
}
