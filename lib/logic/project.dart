import 'package:gtd_client/logic/complex_element.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/tag.dart';

class Project extends ComplexElement<Project> {
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
    assert(!_finish.isBefore(_start));
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
  Map<int, Project> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: Project(
        tags: Tag.instance
            .fromJsonList(json['etiquetas'] as List<dynamic>)
            .keys
            .toList(),
        tasks: Task.instance
            .fromJsonList(json['tareas'] as List<dynamic>)
            .keys
            .toList(),
        notes: Note.instance
            .fromJsonList(json['notas'] as List<dynamic>)
            .keys
            .toList(),
        start: DateTime.parse(json['inicio']),
        finish: DateTime.parse(json['fin']),
        description: json['descripcion'],
        state: json['estado'],
        name: json['nombre'],
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'nombre': name,
      'inicio': _start,
      'fin': _finish,
      'descripcion': description,
      'estado': state,
    };
  }
}
