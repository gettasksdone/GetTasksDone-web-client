import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/task.dart';

class UserData {
  static final UserData _instance = UserData._userData();

  Map<int, CheckItem> _checkItems;
  Map<int, Project> _projects;
  Map<int, String> _contexts;
  Map<int, String> _tags;
  Map<int, Task> _tasks;
  Map<int, Note> _notes;

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

  List<CheckItem> getCheckItems() {
    return _checkItems.values.toList();
  }

  List<Project> getProjects() {
    return _projects.values.toList();
  }

  List<String> getContexts() {
    return _contexts.values.toList();
  }

  List<String> getTags() {
    return _tags.values.toList();
  }

  List<Task> getTasks() {
    return _tasks.values.toList();
  }

  List<Note> getNotes() {
    return _notes.values.toList();
  }

  CheckItem? getCheckItem(int id) {
    if (_checkItems.containsKey(id)) {
      return _checkItems[id];
    }

    return null;
  }

  Project? getProject(int id) {
    if (_projects.containsKey(id)) {
      return _projects[id];
    }

    return null;
  }

  String? getContext(int id) {
    if (_contexts.containsKey(id)) {
      return _contexts[id];
    }

    return null;
  }

  String? getTag(int id) {
    if (_tags.containsKey(id)) {
      return _tags[id];
    }

    return null;
  }

  Task? getTask(int id) {
    if (_tasks.containsKey(id)) {
      return _tasks[id];
    }

    return null;
  }

  Note? getNote(int id) {
    if (_notes.containsKey(id)) {
      return _notes[id];
    }

    return null;
  }

  void addCheckItem(int id, CheckItem checkItem) {
    assert(!(_checkItems.containsKey(id)));

    _checkItems[id] = checkItem;
  }

  void addProject(int id, Project project) {
    assert(!(_projects.containsKey(id)));

    _projects[id] = project;
  }

  void addContext(int id, String context) {
    assert(!(_contexts.containsKey(id)));

    _contexts[id] = context;
  }

  void addTag(int id, String tag) {
    assert(!(_tags.containsKey(id)));

    _tags[id] = tag;
  }

  void addTask(int id, Task task) {
    assert(!(_tasks.containsKey(id)));

    _tasks[id] = task;
  }

  void addNote(int id, Note note) {
    assert(!(_notes.containsKey(id)));

    _notes[id] = note;
  }

  void removeCheckItem(int id) {
    _checkItems.remove(id);
  }

  void removeProject(int id) {
    _projects.remove(id);
  }

  void removeContext(int id) {
    _contexts.remove(id);
  }

  void removeTag(int id) {
    _tags.remove(id);
  }

  void removeTask(int id) {
    _tasks.remove(id);
  }

  void removeNote(int id) {
    _notes.remove(id);
  }

  void updateCheckItem(int id, CheckItem checkItem) {
    assert(_checkItems.containsKey(id));

    _checkItems[id] = checkItem;
  }

  void updateProject(int id, Project project) {
    assert(_projects.containsKey(id));

    _projects[id] = project;
  }

  void updateContext(int id, String context) {
    assert(_contexts.containsKey(id));

    _contexts[id] = context;
  }

  void updateTag(int id, String tag) {
    assert(_tags.containsKey(id));

    _tags[id] = tag;
  }

  void updateTask(int id, Task task) {
    assert(_tasks.containsKey(id));

    _tasks[id] = task;
  }

  void updateNote(int id, Note note) {
    assert(_notes.containsKey(id));

    _notes[id] = note;
  }
}
