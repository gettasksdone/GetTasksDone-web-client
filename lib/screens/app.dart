import 'package:gtd_client/providers/session_token.dart';
import 'package:gtd_client/widgets/app_button_tile.dart';
import 'package:gtd_client/widgets/app_title_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/views/tasks_view.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  static const EdgeInsets _textPadding = EdgeInsets.only(
    bottom: paddingAmount,
    left: paddingAmount,
  );
  static const List<Widget> _views = [
    TasksView(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  int _viewIndex = 0;
  int _inbox = 10;

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted && (ref.watch(sessionTokenProvider) == null)) {
        context.go('/');
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
      body: Container(
        decoration: background,
        child: Row(
          children: [
            SizedBox(
              width: 350.0,
              child: ListView(
                children: [
                  const SizedBox(height: 150.0),
                  const Padding(
                    padding: _textPadding,
                    child: AppTitleText('CAPTURA'),
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    icon: Icons.inbox,
                    onTap: () => _setView(0),
                    text: 'Bandeja de entrada  $_inbox',
                  ),
                  const Padding(
                    padding: _textPadding,
                    child: AppTitleText('CATEGORIZA'),
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    text: 'Lo siguiente',
                    onTap: () => _setView(1),
                    icon: Icons.arrow_circle_right,
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    text: 'Esperando',
                    icon: Icons.coffee,
                    onTap: () => _setView(2),
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    text: 'Agendado',
                    onTap: () => _setView(3),
                    icon: Icons.next_plan_outlined,
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    text: 'Algún día',
                    onTap: () => _setView(4),
                    icon: Icons.landscape_outlined,
                  ),
                  const Padding(
                    padding: _textPadding,
                    child: AppTitleText('PRIORIZA'),
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    icon: Icons.star,
                    text: 'Importante',
                    onTap: () => _setView(5),
                  ),
                  const Padding(
                    padding: _textPadding,
                    child: AppTitleText('ORGANIZA'),
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    text: 'Proyectos',
                    onTap: () => _setView(6),
                    icon: Icons.personal_video,
                  ),
                  const SizedBox(height: paddingAmount),
                  AppButtonTile(
                    text: 'Etiquetas',
                    icon: Icons.label,
                    onTap: () => _setView(7),
                  ),
                ],
              ),
            ),
            Expanded(child: _views[_viewIndex]),
          ],
        ),
      ),
    );
  }
}
