import 'package:gtd_client/widgets/stateful_solid_button.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/username.dart';
import 'package:gtd_client/views/projects.dart';
import 'package:flutter/material.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  static const Map<String, IconData> _icons = {
    'Contextos': Icons.landscape_outlined,
    'Proyectos': Icons.personal_video,
    'Etiquetas': Icons.label,
  };
  static const Map<String, Widget> _views = {
    'Proyectos': ProjectsView(),
    'Contextos': Placeholder(),
    'Etiquetas': Placeholder(),
  };

  String _viewKey = 'Proyectos';

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

    return Scaffold(
      body: Stack(
        children: [
          _views[_viewKey]!,
          SizedBox(
            width: 290.0,
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 120.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: paddingAmount),
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
                        text: key,
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
                    child: StatefulSolidButton(
                      textSize: 25.0,
                      color: Colors.red,
                      text: 'Cerrar sesión',
                      size: const Size(100.0, 60.0),
                      onPressed: () async {
                        ref.read(usernameProvider.notifier).set(null);
                        ref.read(sessionTokenProvider.notifier).set(null);
                        ref.read(completedRegistryProvider.notifier).set(false);
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
}
