import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/widgets/button_tile.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/views/projects.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  static const double _menuWidth = 350.0;
  static const List<Widget> _views = [
    ProjectsView(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  int _viewIndex = 0;

  @override
  void initState() {
    super.initState();

    if (testNavigation) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(sessionTokenProvider) == null) {
        context.go('/');
      }

      if (!ref.watch(completedRegistryProvider)) {
        context.go('/complete_registry');
      }
    });
  }

  void _setView(int viewIndex) {
    setState(() {
      _viewIndex = viewIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _views[_viewIndex],
          SizedBox(
            width: _menuWidth,
            child: ListView(
              children: [
                const SizedBox(
                  height: 120.0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 40.0,
                      left: 20.0,
                    ),
                    child: Text(
                      appName,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: paddingAmount),
                ButtonTile(
                  text: 'Proyectos',
                  onTap: () => _setView(0),
                  icon: Icons.personal_video,
                ),
                const SizedBox(height: paddingAmount),
                ButtonTile(
                  text: 'Contextos',
                  onTap: () => _setView(1),
                  icon: Icons.landscape_outlined,
                ),
                const SizedBox(height: paddingAmount),
                ButtonTile(
                  text: 'Tareas',
                  icon: Icons.inbox,
                  onTap: () => _setView(2),
                ),
                const SizedBox(height: paddingAmount),
                ButtonTile(
                  text: 'Etiquetas',
                  icon: Icons.label,
                  onTap: () => _setView(3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
