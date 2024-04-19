import 'package:gtd_client/logic/complex_item.dart';
import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/tag.dart';
import 'package:intl/intl.dart';

class Task extends ComplexItem<Task> {
  static const String waiting = 'esperando';
  static const String someDay = 'algun día';
  static const String done = 'completado';
  static const String start = 'empezar';
  static const List<String> selectableStates = [start, waiting, someDay];
  static final Task instance = Task();
  static final DateFormat _backEndDateFormat = DateFormat(
    'yyyy-MM-dd hh:mm:ss',
  );

  final Set<int> _checkItems;
  final DateTime created;

  DateTime? _expiration;
  String? description;
  int? contextId;
  String state;
  int priority;

  Task({
    super.id,
    super.notes,
    super.tags,
    this.description,
    this.contextId,
    this.state = start,
    this.priority = 0,
    Set<int>? checkItems,
    DateTime? expiration,
    DateTime? created,
  })  : created = created ?? DateTime.now(),
        _checkItems = checkItems ?? {},
        _expiration = expiration {
    if (_expiration != null) {
      assert(!_expiration!.isBefore(this.created));
    }
  }

  Set<int> get checkItems => _checkItems;
  DateTime? get expiration => _expiration;

  void setExpiration(DateTime? expiration) {
    _expiration = expiration;

    if (_expiration != null) {
      assert(_expiration!.isAfter(created));
    }
  }

  @override
  Map<int, Task> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: Task(
        id: json['id'],
        checkItems: CheckItem.instance
            .fromJsonList(json['checkItems'] as List<dynamic>)
            .keys
            .toSet(),
        tags: Tag.instance
            .fromJsonList(json['etiquetas'] as List<dynamic>)
            .keys
            .toSet(),
        notes: Note.instance
            .fromJsonList(json['notas'] as List<dynamic>)
            .keys
            .toSet(),
        expiration:
            json.containsKey('vencimiento') && (json['vencimiento'] != null)
                ? DateTime.parse(json['vencimiento'])
                : null,
        contextId: Context.instance.fromJson(json['contexto']).keys.first,
        created: DateTime.parse(json['creacion']),
        description: json['descripcion'],
        priority: json['prioridad'],
        state: json['estado'],
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    assert(description != null);
    assert(contextId != null);

    return {
      'contexto': {'id': contextId},
      'descripcion': description,
      'vencimiento':
          _expiration != null ? _backEndDateFormat.format(_expiration!) : null,
      'prioridad': priority,
      'creacion': _backEndDateFormat.format(created),
      'estado': state,
    };
  }
}
