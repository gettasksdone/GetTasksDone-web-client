import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
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
  static const double _listTileFontSize = 23.0;
  static const double _labelFontSize = 17.0;
  static const double _leadingWidth = 45.0;
  static const double _iconSize = 35.0;
  static const EdgeInsets _listTilePadding = EdgeInsets.only(
    bottom: paddingAmount,
  );
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
  int _entrada = 10;

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

  void _setView(BuildContext context, int viewIndex) {
    setState(() {
      _viewIndex = viewIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

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
                  Padding(
                    padding: _textPadding,
                    child: Text(
                      'CAPTURA',
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: _labelFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 0),
                      leading: const Icon(
                        Icons.inbox,
                        size: _iconSize,
                      ),
                      title: Text('Bandeja de entrada  $_entrada'),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _textPadding,
                    child: Text(
                      'CATEGORIZA',
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: _labelFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 1),
                      title: const Text('Lo siguiente'),
                      leading: const Icon(
                        Icons.arrow_circle_right,
                        size: _iconSize,
                      ),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 2),
                      title: const Text('Esperando'),
                      leading: const Icon(
                        Icons.coffee,
                        size: _iconSize,
                      ),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 3),
                      title: const Text('Agendado'),
                      leading: const Icon(
                        Icons.next_plan_outlined,
                        size: _iconSize,
                      ),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 4),
                      title: const Text('Algún día'),
                      leading: const Icon(
                        Icons.landscape_outlined,
                        size: _iconSize,
                      ),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _textPadding,
                    child: Text(
                      'PRIORIZA',
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: _labelFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 5),
                      leading: const Icon(
                        Icons.star,
                        size: _iconSize,
                      ),
                      title: const Text('Importante'),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _textPadding,
                    child: Text(
                      'ORGANIZA',
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: _labelFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 6),
                      leading: const Icon(
                        Icons.personal_video,
                        size: _iconSize,
                      ),
                      title: const Text('Proyectos'),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
                  ),
                  Padding(
                    padding: _listTilePadding,
                    child: ListTile(
                      iconColor: colors.secondary,
                      minLeadingWidth: _leadingWidth,
                      onTap: () => _setView(context, 7),
                      leading: const Icon(
                        Icons.label,
                        size: _iconSize,
                      ),
                      title: const Text('Etiquetas'),
                      titleTextStyle: TextStyle(
                        color: colors.onSecondary,
                        fontSize: _listTileFontSize,
                      ),
                    ),
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
