import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/providers/initialized_app.dart';
import 'package:gtd_client/screens/complete_registry.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/screens/initializing.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/screens/sign_in.dart';
import 'package:gtd_client/screens/sign_up.dart';
import 'package:gtd_client/screens/app.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
GoRouter? _previousRouter;

const String _signInPage = 'sign_in';
const String _signInPath = '/$_signInPage';

const String _signUpPage = 'sign_up';
const String _signUpPath = '/$_signUpPage';

const String _completeRegistryPage = 'complete_registry';
const String _completeRegistryPath = '/$_completeRegistryPage';

const String _appPage = 'app';
const String _appPath = '/$_appPage';

final Provider<GoRouter> routerProvider = Provider((ref) {
  final GoRouter router = GoRouter(
    navigatorKey: _navigatorKey,
    initialLocation:
        _previousRouter?.routerDelegate.currentConfiguration.fullPath,
    redirect: (context, state) {
      if (testNavigation) {
        return null;
      }

      if (!ref.watch(initializedAppProvider)) {
        if (state.matchedLocation != '/') {
          debugPrint('Redirecting to /: Not initialized');
          return '/';
        }

        return null;
      }

      if (ref.watch(sessionTokenProvider) == null) {
        if (state.matchedLocation == _signInPath) {
          return null;
        }

        if (state.matchedLocation == _signUpPath) {
          return null;
        }

        debugPrint('Redirecting to $_signInPath: Null token');

        return _signInPath;
      }

      if (!ref.watch(completedRegistryProvider)) {
        if (state.matchedLocation != _completeRegistryPath) {
          debugPrint(
            'Redirecting to $_completeRegistryPath: Missing additional info',
          );
          return _completeRegistryPath;
        }

        return null;
      }

      if (state.matchedLocation != _appPath) {
        debugPrint('Redirecting to $_appPath');
        return _appPath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const InitializingScreen(),
        routes: [
          GoRoute(
            path: _signInPage,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SignInScreen()),
          ),
          GoRoute(
            path: _signUpPage,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SignUpScreen()),
          ),
          GoRoute(
            path: _appPage,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AppScreen()),
          ),
          GoRoute(
            path: _completeRegistryPage,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CompleteRegistryScreen()),
          ),
        ],
      ),
    ],
  );

  _previousRouter = router;

  return router;
});
