import 'package:gtd_client/widgets/custom_progress_indicator.dart';
import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/providers/inbox_count.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/username.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/views/contexts.dart';
import 'package:gtd_client/views/inbox.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  static const String _inboxKey = 'Bandeja de entrada';
  static const Map<String, IconData> _icons = {
    _inboxKey: Icons.inbox,
    'Agendado': Icons.next_plan_outlined,
    'Contextos': Icons.landscape_outlined,
    'Proyectos': Icons.personal_video,
  };
  static const Map<String, Widget> _views = {
    _inboxKey: InboxView(),
    'Agendado': Placeholder(),
    'Contextos': ContextsView(),
    'Proyectos': Placeholder(),
  };

  final UserData _userData = UserData();
  List<String>? _responses;

  String _viewKey = _inboxKey;

  Future<List<String>> _getUserData() async {
    if (_responses != null) {
      return _responses!;
    }

    final Map<String, String> requestHeaders = headers(ref);
    final List<String> responses = [];

    http.Response response = await http.get(
      Uri.parse('$serverUrl/project/authed'),
      headers: requestHeaders,
    );

    debugPrint('/project/authed call status code: ${response.statusCode}');

    responses.add(response.body);

    response = await http.get(
      Uri.parse('$serverUrl/context/authed'),
      headers: requestHeaders,
    );

    debugPrint('/context/authed call status code: ${response.statusCode}');

    responses.add(response.body);

    _responses = responses;

    return responses;
  }

  void _setView(String viewKey) {
    setState(() {
      _viewKey = viewKey;
    });
  }

  Color _getButtonColor(ColorScheme colors, String buttonKey) {
    if (_viewKey == buttonKey) {
      return colors.primary;
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    Color buttonColor(String buttonKey) => _getButtonColor(colors, buttonKey);

    return FutureBuilder(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<String> responses = snapshot.data!;

            _userData.decodeProjects(responses[0]);
            _userData.decodeContexts(responses[1]);

            ref.read(inboxCountProvider.notifier).set(
                  _userData.getInboxProject().tasks.length,
                );

            return Scaffold(
              body: Stack(
                children: [
                  _views[_viewKey]!,
                  SizedBox(
                    width: 340.0,
                    child: Padding(
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 120.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: paddingAmount),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 30.0),
                                  const Text(
                                    appName,
                                    style: TextStyle(fontSize: 30.0),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    ref.watch(usernameProvider)!,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          for (final String key in _views.keys)
                            Padding(
                              padding: rowPadding,
                              child: SolidIconButton(
                                text: key == _inboxKey
                                    ? '$key ${ref.watch(inboxCountProvider)}'
                                    : key,
                                innerSize: 22.0,
                                icon: _icons[key]!,
                                color: buttonColor(key),
                                innerPadding: cardPadding,
                                onPressed: () => _setView(key),
                              ),
                            ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: LoadingSolidButton(
                              textSize: 25.0,
                              color: Colors.red,
                              text: 'Cerrar sesión',
                              size: const Size(100.0, 60.0),
                              onPressed: () async {
                                ref.read(usernameProvider.notifier).set(null);
                                ref
                                    .read(sessionTokenProvider.notifier)
                                    .set(null);
                                ref
                                    .read(completedRegistryProvider.notifier)
                                    .set(false);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(body: CustomProgressIndicator());
        });
  }
}
