import 'package:gtd_client/logic/complex_element.dart';

class Project extends ComplexElement {
  final List<int> _tasks;
  final int id;

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
    required this.id,
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
}
