import 'package:gtd_client/dialogs/inbox_task_modal.dart' as task_modal;
import 'package:gtd_client/dialogs/context_modal.dart' as context_modal;
import 'package:gtd_client/widgets/custom_progress_indicator.dart';
import 'package:gtd_client/widgets/theme_segmented_button.dart';
import 'package:gtd_client/widgets/loading_solid_button.dart';
import 'package:gtd_client/providers/completed_registry.dart';
import 'package:gtd_client/widgets/custom_split_view.dart';
import 'package:gtd_client/widgets/solid_icon_button.dart';
import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/providers/inbox_count.dart';
import 'package:gtd_client/utilities/extensions.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/providers/username.dart';
import 'package:gtd_client/providers/new_user.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/views/projects.dart';
import 'package:gtd_client/views/contexts.dart';
import 'package:gtd_client/views/tasks.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  static const String _inboxKey = 'Bandeja de entrada';
  static final UserData _userData = UserData();
  static const Map<String, IconData> _icons = {
    _inboxKey: Icons.inbox,
    'Esperando': Icons.coffee,
    'Agendado': Icons.next_plan_outlined,
    'Algún día': Icons.landscape_outlined,
    'Importante': Icons.star,
    'Completado': Icons.check_circle_outline,
    'Todas las tareas': Icons.all_inbox,
    'Contextos': Icons.pin_drop,
    'Proyectos': Icons.personal_video,
  };
  static final Map<String, Widget> _views = {
    _inboxKey: TasksView(inboxView: true, showTask: _userData.taskInInbox),
    'Esperando': TasksView(
      taskBuilder: () => Task(state: Task.waiting),
      showTask: (task) => task.state == Task.waiting,
    ),
    'Agendado': TasksView(
      taskBuilder: () => Task(expiration: DateTime.now()),
      showTask: (task) =>
          (task.state != Task.done) && (task.expiration != null),
    ),
    'Algún día': TasksView(
      taskBuilder: () => Task(state: Task.someDay),
      showTask: (task) => task.state == Task.someDay,
    ),
    'Importante': TasksView(
      taskBuilder: () => Task(priority: 1),
      showTask: (task) => (task.state != Task.done) && (task.priority != 0),
    ),
    'Completado': TasksView(showTask: (task) => task.state == Task.done),
    'Todas las tareas': TasksView(showTask: (task) => true),
    'Contextos': const ContextsView(),
    'Proyectos': const ProjectsView(),
  };

  String _viewKey = _inboxKey;
  bool _initialized = false;
  bool _bigScreen = false;
  bool _forceNewContext = false;

  void _setView(BuildContext context, String viewKey) {
    setState(() {
      _viewKey = viewKey;
    });

    if (!_bigScreen) {
      context.pop();
    }
  }

  Color _getButtonTextColor(ColorScheme colors, String buttonKey) {
    if (_viewKey == buttonKey) {
      return colors.onPrimary;
    }

    return colors.onSecondary;
  }

  Color _getButtonColor(ColorScheme colors, String buttonKey) {
    if (_viewKey == buttonKey) {
      return colors.primary;
    }

    return Colors.transparent;
  }

  void _createInboxTask(BuildContext context) {
    setState(() {
      task_modal.showModal(context, ref, () => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return FutureBuilder(
        future: getUserDataResponse(ref),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _userData.loadUserData(ref, snapshot.data!);

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => setState(() {
                _initialized = true;
                _forceNewContext =
                    _userData.contexts.isEmpty && ref.watch(newUserProvider);
              }),
            );
          }

          return const Scaffold(body: Center(child: CustomProgressIndicator()));
        },
      );
    }

    if (_forceNewContext) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _forceNewContext = false;

          context_modal.showModal(
            allowDismiss: false,
            context,
            ref,
            () => setState(() {
              ref.read(newUserProvider.notifier).set(false);
            }),
            null,
          );
        });
      });
    }

    final ColorScheme colors = context.colorScheme;

    _bigScreen = context.parentSize.width >= 1530.0;

    return CustomSplitView(
      bigScreen: _bigScreen,
      view: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: _views[_viewKey]!,
      ),
      floatingActionButton: Tooltip(
        message: 'Agregar tarea a la bandeja de entrada',
        child: FloatingActionButton(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          onPressed: () => _createInboxTask(context),
          child: const Icon(Icons.add),
        ),
      ),
      menu: Padding(
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
            Expanded(
              child: ListView(
                children: [
                  for (final String key in _views.keys)
                    Padding(
                      padding: rowPadding,
                      child: SolidIconButton(
                        innerSize: 22.0,
                        icon: _icons[key]!,
                        innerPadding: cardPadding,
                        color: _getButtonColor(colors, key),
                        innerColor: _getButtonTextColor(colors, key),
                        text: key == _inboxKey
                            ? '$key ${ref.watch(inboxCountProvider)}'
                            : key,
                        onPressed: () => _setView(context, key),
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: padding,
              child: ThemeSegmentedButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: LoadingSolidButton(
                textSize: 25.0,
                color: Colors.red,
                text: 'Cerrar sesión',
                size: const Size(100.0, 60.0),
                onPressed: () async {
                  _userData.clear();

                  ref.read(usernameProvider.notifier).set(null);
                  ref.read(sessionTokenProvider.notifier).set(null);
                  ref.read(completedRegistryProvider.notifier).set(false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
