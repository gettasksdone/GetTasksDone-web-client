import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gtd_client/providers/inbox_count.dart';
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

  Map<int, int> _taskToProject;
  int? _inboxProjectId;

  UserData._userData()
      : _taskToProject = {},
        _checkItems = {},
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

  int getProjectIdOfTask(int id) {
    return _taskToProject[id]!;
  }

  void putTask(WidgetRef ref, Task task, int projectId) {
    final bool existingTask = _taskToProject.containsKey(task.id);

    if (existingTask && (_taskToProject[task.id]! != projectId)) {
      if (_taskToProject[task.id] == _inboxProjectId) {
        ref.read(inboxCountProvider.notifier).substractOne();
      }

      changeProjectOfTask(task.id, projectId);
    }

    _taskToProject[task.id] = projectId;
    _tasks[task.id] = task;

    if (taskInInbox(task)) {
      ref.read(inboxCountProvider.notifier).addOne();
    }
  }

  void putContext(int id, Context context) {
    _contexts[id] = context;
  }

  void putProject(int id, Project project) {
    _projects[id] = project;
  }

  void updateTask(WidgetRef ref, Task task, int? projectId) {
    _tasks[task.id] = task;

    if (projectId != null) {
      changeProjectOfTask(task.id, projectId);
    }
  }

  void changeProjectOfTask(int taskId, int projectId) {
    _projects[_taskToProject[taskId]!]!.removeTask(taskId);
    _projects[projectId]!.addTask(taskId);

    _taskToProject[taskId] = projectId;
  }

  void removeTask(WidgetRef? ref, int id) {
    _projects[_taskToProject[id]]!.removeTask(id);
    _taskToProject.remove(id);

    if (taskInInbox(_tasks[id]!)) {
      ref!.read(inboxCountProvider.notifier).substractOne();
    }

    _tasks.remove(id);
  }

  void removeProject(int id) {
    for (final int id in _projects[id]!.tasks) {
      removeTask(null, id);
    }

    _projects.remove(id);
  }

  void clear() {
    _taskToProject = {};
    _checkItems = {};
    _projects = {};
    _contexts = {};
    _tasks = {};
    _notes = {};
    _tags = {};
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

        _taskToProject[task.entries.first.key] = project.entries.first.key;

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

  void loadUserData(WidgetRef ref, List<String> responses) {
    decodeProjects(responses[0]);
    decodeContexts(responses[1]);

    ref.read(inboxCountProvider.notifier).set(
        getInboxProject().tasks.where((id) => taskInInbox(_tasks[id]!)).length);
  }

  bool taskInInbox(Task task) =>
      (task.expiration == null) &&
      (task.state == Task.start) &&
      (task.priority == 0) &&
      (getProjectIdOfTask(task.id) == _inboxProjectId);
}
