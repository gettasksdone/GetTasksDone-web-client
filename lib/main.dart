import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/providers/theme_picker.dart';
import 'package:gtd_client/providers/routing.dart';
import 'package:gtd_client/utilities/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  WidgetsFlutterBinding.ensureInitialized();

  final ProviderContainer container = ProviderContainer();

  await container.read(themePickerProvider.notifier).initialize();

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: AppTheme.light,
      title: 'Get Tasks Done',
      darkTheme: AppTheme.dark,
      routerConfig: ref.watch(routerProvider),
      themeMode: ref.watch(themePickerProvider),
    );
  }
}
