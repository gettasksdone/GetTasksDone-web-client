import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/utilities/headers.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

void _printStatusCode(String url, http.Response response) {
  debugPrint('$url call status code: ${response.statusCode}');
}

Future<List<String>> getUserDataResponse(WidgetRef ref) async {
  final Map<String, String> requestHeaders = headers(ref);
  final List<String> responses = [];

  String url = '$serverUrl/project/authed';

  http.Response response = await http.get(
    Uri.parse(url),
    headers: requestHeaders,
  );

  _printStatusCode(url, response);

  responses.add(utf8.decode(response.bodyBytes));

  url = '$serverUrl/context/authed';

  response = await http.get(
    Uri.parse(url),
    headers: requestHeaders,
  );

  _printStatusCode(url, response);

  responses.add(utf8.decode(response.bodyBytes));

  return responses;
}

Future<void> postContext(
  WidgetRef ref,
  Context context,
  void Function(int) onSucess,
) async {
  const String url = '$serverUrl/context/createContext';

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers(ref),
    body: jsonEncode(context.toJson()),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess(int.parse(response.body));
  }
}

Future<void> patchContext(
  WidgetRef ref,
  Context context,
  VoidCallback onSucess,
) async {
  final String url = '$serverUrl/context/update/${context.id}';

  final http.Response response = await http.patch(
    Uri.parse(url),
    headers: headers(ref),
    body: jsonEncode(context.toJson()),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess();
  }
}

Future<void> deleteContext(
  WidgetRef ref,
  int id,
  VoidCallback onSucess,
) async {
  final String url = '$serverUrl/context/delete/$id';

  final http.Response response = await http.delete(
    Uri.parse(url),
    headers: headers(ref),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess();
  }
}

Future<void> postTask(
  WidgetRef ref,
  Task task,
  int projectId,
  void Function(int) onSucess,
) async {
  final String url = '$serverUrl/task/create?ProjectID=$projectId';

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers(ref),
    body: jsonEncode(task.toJson()),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess(int.parse(response.body));
  }
}

Future<void> patchTask(
  WidgetRef ref,
  Task task,
  int? projectId,
  VoidCallback onSucess,
) async {
  String url = '$serverUrl/task/update/${task.id}';

  if (projectId != null) {
    url += '?ProjectID=$projectId';
  }

  final http.Response response = await http.patch(
    Uri.parse(url),
    headers: headers(ref),
    body: jsonEncode(task.toJson()),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess();
  }
}

Future<void> deleteTask(
  WidgetRef ref,
  int id,
  VoidCallback onSucess,
) async {
  final String url = '$serverUrl/task/delete/$id';

  final http.Response response = await http.delete(
    Uri.parse(url),
    headers: headers(ref),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess();
  }
}

Future<void> postProject(
  WidgetRef ref,
  Project project,
  void Function(int) onSucess,
) async {
  const String url = '$serverUrl/project/create';

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers(ref),
    body: jsonEncode(project.toJson()),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess(int.parse(response.body));
  }
}

Future<void> patchProject(
  WidgetRef ref,
  Project project,
  VoidCallback onSucess,
) async {
  final String url = '$serverUrl/project/update/${project.id}';

  final http.Response response = await http.patch(
    Uri.parse(url),
    headers: headers(ref),
    body: jsonEncode(project.toJson()),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess();
  }
}

Future<void> deleteProject(
  WidgetRef ref,
  int id,
  VoidCallback onSucess,
) async {
  final String url = '$serverUrl/project/delete/$id';

  final http.Response response = await http.delete(
    Uri.parse(url),
    headers: headers(ref),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess();
  }
}

Future<void> postUserData(
  WidgetRef ref,
  String name,
  String phoneNumber,
  String jobTitle,
  String department,
  VoidCallback onSucess,
  VoidCallback otherwise,
) async {
  const String url = '$serverUrl/userData/create';

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers(ref),
    body: jsonEncode(
      <String, dynamic>{
        'nombre': name,
        'telefono': phoneNumber.replaceAll('+', ''),
        'puesto': jobTitle,
        'departamento': department,
      },
    ),
  );

  _printStatusCode(url, response);

  if (response.statusCode == 200) {
    onSucess();
  } else {
    otherwise();
  }
}

Future<int> getUserDataAuthed(String sessionToken) async {
  const String url = '$serverUrl/userData/authed';

  int statusCode = 403;

  try {
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $sessionToken',
      }..addAll(contentType),
    );

    statusCode = response.statusCode;
  } catch (exception) {
    debugPrint(
      'Exception occured trying in api.getUserDataAuthed(): $exception',
    );
  }

  debugPrint('Initial $url call status code: $statusCode');

  return statusCode;
}

Future<http.Response> postAuthLogin(String username, String password) async {
  const String url = '$serverUrl/auth/login';

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: contentType,
    body: jsonEncode(
      <String, dynamic>{
        'username': username,
        'password': password,
      },
    ),
  );

  _printStatusCode(url, response);

  return response;
}

Future<http.Response> postAuthRegister(
  String username,
  String password,
  String email,
) async {
  const String url = '$serverUrl/auth/register';

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: contentType,
    body: jsonEncode(
      <String, dynamic>{
        'username': username,
        'password': password,
        'email': email,
      },
    ),
  );

  _printStatusCode(url, response);

  return response;
}
