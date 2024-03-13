import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/providers/initialized_app.dart';
import 'package:gtd_client/screens/complete_registry.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/themes.dart';
import 'package:gtd_client/screens/sign_in.dart';
import 'package:gtd_client/screens/sign_up.dart';
import 'package:gtd_client/screens/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MaterialApp.router(
        theme: AppTheme.dark,
        routerConfig: _router,
        title: 'Get Tasks Done',
      ),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _Initializer(),
      routes: [
        GoRoute(
          path: 'sign_in',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignInScreen()),
        ),
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

class _Initializer extends ConsumerWidget {
  const _Initializer();

  Future<Map<String, dynamic>> _getInitialData() async {
    if (testNavigation) {
      return {
        'token': 'sessionToken',
        'completedRegistry': true,
      };
    }

    const FlutterSecureStorage storage = FlutterSecureStorage();

    if (await storage.containsKey(key: 'session_token')) {
      final String? sessionToken = await storage.read(key: 'session_token');

      debugPrint('Session token: $sessionToken');

      int statusCode = 403;

      try {
        final http.Response response = await http.get(
          Uri.parse('$serverUrl/userData/authed'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $sessionToken',
          },
        );

        statusCode = response.statusCode;
      } catch (exception) {
        debugPrint('Exception occured trying to get userData: $exception');
      }

      debugPrint('Initial /userData/authed call status code: $statusCode');

      switch (statusCode) {
        case 200:
          return {
            'token': sessionToken,
            'completedRegistry': true,
          };
        case 404:
          return {
            'token': sessionToken,
            'completedRegistry': false,
          };
        default:
          await storage.delete(key: 'session_token');
      }
    }

    return {
      'token': null,
      'completedRegistry': false,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: _getInitialData(),
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> snapshot,
        ) {
          if (snapshot.hasData) {
            final Map<String, dynamic> data = snapshot.data!;

            final bool completedRegistry = data['completedRegistry'];
            final bool validToken = data['token'] != null;

            if (validToken) {
              ref.read(sessionTokenProvider.notifier).set(data['token']!);
            }

            ref.read(completedRegistryProvider.notifier).set(
                  completedRegistry,
                );

            ref.read(initializedAppProvider.notifier).done();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              late final String route;

              if (validToken && completedRegistry) {
                route = '/app';
              } else if (validToken) {
                route = '/complete_registry';
              } else {
                route = '/sign_in';
              }

              debugPrint('Redirecting to $route');

              context.go(route);
            });
          }

          return Container(
            color: context.theme.canvasColor,
            child: Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
                backgroundColor: Colors.transparent,
              ),
            ),
          );
        });
  }
}
