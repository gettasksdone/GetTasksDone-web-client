import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/logic/user_data.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/api.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

void showDeleteContextDialog(BuildContext buildContext, WidgetRef ref,
    VoidCallback setParentState, Context context) {
  final UserData userData = UserData();

  showDialog(
    context: buildContext,
    builder: (BuildContext alertContext) {
      final Set<Task> tasks = userData.getContextTasks(context.id);

      return AlertDialog(
        title: Text('¿Borrar ${context.name}?'),
        content: tasks.isEmpty
            ? null
            : SizedBox(
                width: 150.0,
                child: Text(
                  'Se borrarían las siguientes tareas: ${tasks.map((Task task) => task.title).join(', ')}',
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => buildContext.pop(),
            child: const Text('Cacelar'),
          ),
          TextButton(
            onPressed: () async {
              await deleteContext(
                ref,
                context.id,
                () async {
                  userData.clear();
                  userData.loadUserData(
                    ref,
                    await getUserDataResponse(ref),
                  );

                  if (buildContext.mounted) {
                    buildContext.pop();
                    buildContext.pop();

                    setParentState();
                  }
                },
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
