import 'package:gtd_client/utilities/constants.dart';
import 'package:gtd_client/logic/complex_item.dart';
import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/tag.dart';

class Task extends ComplexItem<Task> {
  static const String waiting = 'esperando';
  static const String someDay = 'algun día';
  static const String done = 'completado';
  static const String start = 'empezar';
  static const List<String> selectableStates = [start, waiting, someDay];
  static final Task instance = Task();

  final Set<int> _checkItems;
  final DateTime created;

  DateTime? _expiration;
  String? description;
  int? contextId;
  String? title;
  String state;
  int priority;

  Task({
    super.id,
    super.notes,
    super.tags,
    this.description,
    this.contextId,
    this.title,
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
  Task copy() {
    return Task(
      id: id,
      checkItems: Set.from(_checkItems),
      description: description,
      expiration: _expiration,
      notes: Set.from(notes),
      tags: Set.from(tags),
      contextId: contextId,
      priority: priority,
      created: created,
      state: state,
      title: title,
    );
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
        title: json['titulo'],
        state: json['estado'],
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    assert(contextId != null);
    assert(title != null);

    return {
      'vencimiento':
          _expiration != null ? backEndDateFormat.format(_expiration!) : null,
      'creacion': backEndDateFormat.format(created),
      'contexto': {'id': contextId},
      'descripcion': description,
      'prioridad': priority,
      'titulo': title,
      'estado': state,
    };
  }
}
