import 'package:gtd_client/mixins/serializable_mixin.dart';
import 'package:gtd_client/logic/complex_element.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/tag.dart';

class Project extends ComplexElement with SerializableMixin<Project> {
  static final Project instance = Project(
    finish: DateTime.now(),
    start: DateTime.now(),
    description: '',
    state: '',
    name: '',
  );

  final List<int> _tasks;

  String description;
  DateTime _finish;
  DateTime _start;
  String state;
  String name;

  Project({
    required this.description,
    required DateTime finish,
    required DateTime start,
    required this.state,
    required this.name,
    List<int>? tasks,
    List<int>? notes,
    List<int>? tags,
  })  : _tasks = tasks ?? [],
        _finish = finish,
        _start = start,
        super(notes, tags) {
    assert(_start.isBefore(_finish));
  }

  List<int> get tasks => _tasks;

  void setStart(DateTime start) {
    assert(start.isBefore(_finish));

    _start = start;
  }

  void setFinish(DateTime finish) {
    assert(finish.isAfter(_start));

    _finish = finish;
  }

  void addTask(int task) {
    _tasks.add(task);
  }

  void removeTask(int task) {
    _tasks.remove(task);
  }

  @override
  Map<int, Project> deserialize(Map<String, dynamic> data) {
    final Project project = Project(
      tags: Tag.instance.deserializeList(data['etiquetas']).keys.toList(),
      tasks: Task.instance.deserializeList(data['tareas']).keys.toList(),
      notes: Note.instance.deserializeList(data['notas']).keys.toList(),
      start: DateTime.parse(data['inicio']),
      finish: DateTime.parse(data['fin']),
      description: data['descripcion'],
      state: data['estado'],
      name: data['nombre'],
    );

    return {data['id']: project};
  }
}
