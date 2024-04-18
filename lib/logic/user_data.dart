import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/tag.dart';
import 'dart:convert';

class UserData {
  static final UserData _instance = UserData._userData();

  Map<int, CheckItem> _checkItems;
  Map<int, Project> _projects;
  Map<int, Context> _contexts;
  Map<int, Task> _tasks;
  Map<int, Note> _notes;
  Map<int, Tag> _tags;

  int? _inboxProjectId;

  UserData._userData()
      : _checkItems = {},
        _projects = {},
        _contexts = {},
        _tasks = {},
        _notes = {},
        _tags = {};

  factory UserData() {
    return _instance;
  }

  Map<int, CheckItem> get checkItems => _checkItems;
  Map<int, Project> get projects => _projects;
  Map<int, Context> get contexts => _contexts;
  Map<int, Task> get tasks => _tasks;
  Map<int, Note> get notes => _notes;
  Map<int, Tag> get tags => _tags;

  int get inboxId => _inboxProjectId!;

  CheckItem getCheckItem(int id) {
    return _checkItems[id]!;
  }

  Project getProject(int id) {
    return _projects[id]!;
  }

  Context getContext(int id) {
    return _contexts[id]!;
  }

  Tag getTag(int id) {
    return _tags[id]!;
  }

  Task getTask(int id) {
    return _tasks[id]!;
  }

  Note getNote(int id) {
    return _notes[id]!;
  }

  void putTask(int id, Task task) {
    _tasks[id] = task;
  }

  void putContext(int id, Context context) {
    _contexts[id] = context;
  }

  void removeTask(int id) {
    _tasks.remove(id);
  }

  Map<int, Project> decodeProjects(String response) {
    final Iterable<dynamic> json = jsonDecode(response);

    for (final projectJson in json) {
      final Map<int, Project> project = Project.instance.fromJson(projectJson);

      _projects.addAll(project);

      _tags.addAll(Tag.instance.fromJsonList(projectJson["etiquetas"]));
      _notes.addAll(Note.instance.fromJsonList(projectJson["notas"]));

      for (final Map<String, dynamic> taskJson in projectJson["tareas"]) {
        final Map<int, Task> task = Task.instance.fromJson(taskJson);

        _tasks.addAll(task);

        _tags.addAll(Tag.instance.fromJsonList(taskJson["etiquetas"]));
        _notes.addAll(Note.instance.fromJsonList(taskJson["notas"]));
        _checkItems.addAll(CheckItem.instance.fromJsonList(
          taskJson["checkItems"],
        ));
      }
    }

    return _projects;
  }

  Map<int, Context> decodeContexts(String response) {
    _contexts.addAll(Context.instance.decodeList(response));

    return _contexts;
  }

  Project getInboxProject() {
    if (_inboxProjectId != null) {
      return getProject(_inboxProjectId!);
    }

    for (final MapEntry<int, Project> entry in _projects.entries) {
      if (entry.value.name == "inbox") {
        _inboxProjectId = entry.key;

        return entry.value;
      }
    }

    throw UnimplementedError('No inbox project found');
  }
}
