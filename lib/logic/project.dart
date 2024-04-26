import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/complex_item.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/task.dart';
import 'package:gtd_client/logic/tag.dart';

class Project extends ComplexItem<Project> {
  static const String done = 'completado';
  static const String start = 'empezar';
  static const List<String> selectableStates = [start, done];
  static final Project instance = Project();

  final Set<int> _tasks;

  String? description;
  DateTime? _finish;
  DateTime? _start;
  String state;
  String? name;

  Project({
    super.id,
    super.notes,
    super.tags,
    this.description,
    DateTime? finish,
    Set<int>? tasks,
    DateTime? start,
    this.name,
    this.state = start,
  })  : _tasks = tasks ?? {},
        _finish = finish,
        _start = start {
    if ((_finish != null) && (_start != null)) {
      assert(!_finish!.isBefore(_start!));
    }
  }

  DateTime? get finishDate => _finish;
  DateTime? get startDate => _start;
  Set<int> get tasks => _tasks;

  void setStart(DateTime start) {
    if (_finish != null) {
      assert(start.isBefore(_finish!));
    }

    _start = start;
  }

  void setFinish(DateTime finish) {
    if (_start != null) {
      assert(finish.isAfter(_start!));
    }

    _finish = finish;
  }

  void addTask(int id) {
    _tasks.add(id);
  }

  void removeTask(int id) {
    _tasks.remove(id);
  }

  @override
  Map<int, Project> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: Project(
        id: json['id'],
        tags: Tag.instance
            .fromJsonList(json['etiquetas'] as List<dynamic>)
            .keys
            .toSet(),
        tasks: Task.instance
            .fromJsonList(json['tareas'] as List<dynamic>)
            .keys
            .toSet(),
        notes: Note.instance
            .fromJsonList(json['notas'] as List<dynamic>)
            .keys
            .toSet(),
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
    assert(description != null);
    assert(_finish != null);
    assert(_start != null);
    assert(name != null);

    return {
      'nombre': name,
      'inicio': backEndDateFormat.format(_start!),
      'fin': backEndDateFormat.format(_finish!),
      'descripcion': description,
      'estado': state,
    };
  }
}
