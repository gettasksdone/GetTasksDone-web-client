import 'package:gtd_client/screens/complete_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/themes.dart';
import 'package:gtd_client/screens/sign_in.dart';
import 'package:gtd_client/screens/sign_up.dart';
import 'package:gtd_client/screens/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInScreen(),
      routes: [
        GoRoute(
          path: 'sign_up',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignUpScreen()),
        ),
        GoRoute(
          path: 'app',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AppScreen()),
        ),
        GoRoute(
          path: 'complete_registry',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CompleteRegistryScreen()),
        ),
      ],
    ),
  ],
);

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        title: 'Get Tasks Done',
        theme: AppTheme.dark,
        routerConfig: _router,
      ),
    ),
  );
}
