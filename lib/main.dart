import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/utilities/themes.dart';
import 'package:gtd_client/logic/routing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: AppTheme.dark,
      title: 'Get Tasks Done',
      routerConfig: ref.watch(routerProvider),
    );
  }
}
