import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  static const List<Widget> _views = [
    Placeholder(),
  ];

  int _viewIndex = 0;

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

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = context.colorScheme;

    return Scaffold(
      body: _views[_viewIndex],
    );
  }
}
