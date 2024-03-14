import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/project.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/tag.dart';

class UserData {
  static final UserData _instance = UserData._userData();

  Map<int, CheckItem> _checkItems;
  Map<int, Project> _projects;
  Map<int, Context> _contexts;
  Map<int, Task> _tasks;
  Map<int, Note> _notes;
  Map<int, Tag> _tags;

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

  Context? getContext(int id) {
    if (_contexts.containsKey(id)) {
      return _contexts[id];
    }

    return null;
  }

  Tag? getTag(int id) {
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
    _checkItems[id] = checkItem;
  }

  void addProject(int id, Project project) {
    _projects[id] = project;
  }

  void addContext(int id, Context context) {
    _contexts[id] = context;
  }

  void addTag(int id, Tag tag) {
    _tags[id] = tag;
  }

  void addTask(int id, Task task) {
    _tasks[id] = task;
  }

  void addNote(int id, Note note) {
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
}
