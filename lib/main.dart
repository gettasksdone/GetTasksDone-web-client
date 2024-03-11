import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/screens/complete_registry.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/themes.dart';
import 'package:gtd_client/screens/sign_in.dart';
import 'package:gtd_client/screens/sign_up.dart';
import 'package:gtd_client/screens/app.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
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
    const ProviderScope(child: _EagerInitialization()),
  );
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization();

  Future<void> _initiliazeSessionToken(
    BuildContext context,
    WidgetRef ref,
  ) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();

    if (await storage.containsKey(key: 'session_token')) {
      final String? sessionToken = await storage.read(key: 'session_token');

      final http.Response response = await http.get(
        Uri.parse('$serverUrl/userData/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $sessionToken',
        },
      );

      if (response.statusCode == 200) {
        ref.read(sessionTokenProvider.notifier).set(sessionToken!);

        ref
            .read(completedRegistryProvider.notifier)
            .set(response.body.isNotEmpty);
      } else if (response.statusCode == 404) {
        ref.read(sessionTokenProvider.notifier).set(sessionToken!);
      }

      await storage.delete(key: 'session_token');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _initiliazeSessionToken(context, ref);

    return MaterialApp.router(
      title: 'Get Tasks Done',
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
