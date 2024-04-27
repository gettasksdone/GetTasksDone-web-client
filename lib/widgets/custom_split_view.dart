import 'package:gtd_client/utilities/extensions.dart';
import 'package:flutter/material.dart';

class CustomSplitView extends StatelessWidget {
  static const double _appBarHeight = 50.0;
  static const double _menuWidth = 350.0;
  final bool bigScreen;
  final Widget view;
  final Widget menu;

  const CustomSplitView({
    super.key,
    required this.bigScreen,
    required this.view,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;
    final Widget widgetTree;

    if (bigScreen) {
      widgetTree = Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: _appBarHeight),
                Expanded(child: view),
              ],
            ),
            SizedBox(
              width: _menuWidth,
              child: menu,
            ),
          ],
        ),
      );
    } else {
      widgetTree = Scaffold(
        appBar: AppBar(
          toolbarHeight: _appBarHeight,
          backgroundColor: context.theme.canvasColor,
        ),
        drawer: Drawer(
          width: _menuWidth,
          backgroundColor: colors.secondary.darken(20),
          child: menu,
        ),
        body: view,
      );
    }

    return widgetTree;
  }
}
