import 'package:gtd_client/enums/task_length.dart';
import 'package:gtd_client/enums/task_date.dart';
import 'package:uuid/uuid.dart';

class Task {
  final String id = const Uuid().v4();
  String? description;
  TaskDate _category;
  TaskLength length;
  DateTime? _when;
  bool recurring;
  String? tag;
  String name;

  Task({
    required this.name,
    required this.length,
    required TaskDate category,
    this.recurring = false,
    this.description,
    this.tag,
    DateTime? when,
  })  : _when = when,
        _category = category {
    if (_category == TaskDate.saved) {
      assert(_when != null);
    }
  }

  TaskDate get category => _category;

  DateTime get when {
    assert(_category == TaskDate.saved);

    return _when!;
  }

  void setCategory(TaskDate category, DateTime? when) {
    if (category == TaskDate.saved) {
      assert(when != null);
    }

    _category = category;
    _when = when;
  }
}
