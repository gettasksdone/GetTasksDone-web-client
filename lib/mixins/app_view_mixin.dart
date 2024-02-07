import 'package:blackforesttools/providers/session_token.dart';
import 'package:blackforesttools/utilities/constants.dart';
import 'package:blackforesttools/providers/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

mixin AppViewMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late final String _endpoint;

  List<List<String>>? taskStatus;
  bool notifyOnTaskEnd = false;
  bool postTaskError = false;
  String? postTaskMessage;
  List<String>? items;
  String? taskName;

  void appViewMixin(String endpoint) {
    _endpoint = endpoint;
  }

  void postTask(Map<String, dynamic> payload) async {
    if (kDebugMode) {
      setState(() {
        postTaskMessage = 'Task sent to server successfully';
        postTaskError = false;
      });

      return;
    }

    final String? sessionToken = ref.watch(sessionTokenProvider);
    final String? account = ref.watch(accountProvider);

    final http.Response respone = await http.post(
      Uri.parse('$serverUrl/$_endpoint/run'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'session_token': sessionToken,
          'account': account,
          'items': items,
          'task_name': taskName,
          'notify': notifyOnTaskEnd,
        }..addAll(payload),
      ),
    );

    if (respone.statusCode == 200) {
      fetchTasksStatus();

      setState(() {
        postTaskMessage = 'Task sent to server successfully';
        postTaskError = false;
      });

      return;
    }

    setState(() {
      postTaskMessage = 'Error sending task to server';
      postTaskError = true;
    });
  }

  void fetchTasksStatus() async {
    if (kDebugMode) {
      final List<List<String>> status = [
        ['Started...', 'Example Task', 'account@account.acc']
      ];

      setState(() {
        taskStatus = status;
      });

      return;
    }

    final String? sessionToken = ref.watch(sessionTokenProvider);
    final String? account = ref.watch(accountProvider);

    final http.Response respone = await http.post(
      Uri.parse('$serverUrl/$_endpoint/tasks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'session_token': sessionToken,
          'account': account,
        },
      ),
    );

    setState(() {
      taskStatus = (jsonDecode(respone.body) as Map<String, dynamic>)['status'];
    });
  }

  String? validateItems(
    String? itemsAsString,
    String itemName,
    bool Function(String) validator,
  ) {
    if (itemsAsString == null || itemsAsString.isEmpty) {
      return 'Please enter atleast one $itemName';
    }

    int lineIndex = 1;

    final List<String> items = itemsAsString
        .split('\n')
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    for (String item in items) {
      if (!validator(item)) {
        setState(() {
          this.items = null;
        });

        return 'Invalid $itemName [$item] on line ($lineIndex)';
      }

      lineIndex++;
    }

    setState(() {
      this.items = items;
    });

    return null;
  }

  void onNotifyChange(bool checked) {
    setState(() {
      notifyOnTaskEnd = checked;
    });
  }

  String? validateTaskName(String? inputTaskName) {
    if (inputTaskName == null || inputTaskName.isEmpty) {
      return null;
    }

    setState(() {
      taskName = inputTaskName;
    });

    return null;
  }
}
