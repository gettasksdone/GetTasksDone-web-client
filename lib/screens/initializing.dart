import 'package:gtd_client/widgets/custom_progress_indicator.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/providers/initialized_app.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/username.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class InitializingScreen extends ConsumerWidget {
  const InitializingScreen({super.key});

  Future<bool> _getInitialData(WidgetRef ref) async {
    if (testNavigation) {
      return true;
    }

    final String? sessionToken = await SessionToken.readFromStorage();
    bool completedRegistry = false;
    bool validToken = false;

    debugPrint('Session token from storage: $sessionToken');

    if (sessionToken != null) {
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
          completedRegistry = true;
          validToken = true;
          break;
        case 404:
          validToken = true;
          break;
        default:
          break;
      }
    }

    if (validToken) {
      ref.read(usernameProvider.notifier).set(await Username.readFromStorage());
      ref.read(sessionTokenProvider.notifier).set(sessionToken);
    }

    if (completedRegistry) {
      ref.read(completedRegistryProvider.notifier).set(true);
    }

    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: _getInitialData(ref),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint('Finished initialization');

            ref.read(initializedAppProvider.notifier).done();
          }

          return Container(
            color: context.theme.canvasColor,
            child: const Center(child: CustomProgressIndicator()),
          );
        });
  }
}
