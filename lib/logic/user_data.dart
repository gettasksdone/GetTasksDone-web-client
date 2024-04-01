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

  void putCheckItem(int id, CheckItem checkItem) {
    _checkItems[id] = checkItem;
  }

  void putProject(int id, Project project) {
    _projects[id] = project;
  }

  void putContext(int id, Context context) {
    _contexts[id] = context;
  }

  void putTag(int id, Tag tag) {
    _tags[id] = tag;
  }

  void putTask(int id, Task task) {
    _tasks[id] = task;
  }

  void putNote(int id, Note note) {
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
