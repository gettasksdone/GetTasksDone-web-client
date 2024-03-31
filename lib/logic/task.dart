import 'package:gtd_client/logic/complex_element.dart';
import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/tag.dart';

class Task extends ComplexElement<Task> {
  static final Task instance = Task(
    id: -1,
    description: '',
    contextId: -1,
    priority: -1,
    state: '',
  );

  final List<int> _checkItems;
  final DateTime created;

  DateTime? _expiration;
  String description;
  int contextId;
  String state;
  int priority;

  Task({
    required super.id,
    super.notes,
    super.tags,
    required this.description,
    required this.contextId,
    required this.priority,
    required this.state,
    List<int>? checkItems,
    DateTime? expiration,
    DateTime? created,
  })  : created = created ?? DateTime.now(),
        _checkItems = checkItems ?? [],
        _expiration = expiration {
    if (_expiration != null) {
      assert(!_expiration!.isBefore(this.created));
    }
  }

  List<int> get checkItems => _checkItems;
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
            .toList(),
        tags: Tag.instance
            .fromJsonList(json['etiquetas'] as List<dynamic>)
            .keys
            .toList(),
        notes: Note.instance
            .fromJsonList(json['notas'] as List<dynamic>)
            .keys
            .toList(),
        expiration: json.containsKey('vencimiento')
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
    return {
      'contexto': {'id': contextId},
      'descripcion': description,
      'vencimiento': _expiration,
      'prioridad': priority,
      'creacion': created,
      'estado': state,
    };
  }

  @override
  Task withId(int id) {
    return Task(
      id: id,
      description: description,
      expiration: _expiration,
      checkItems: _checkItems,
      contextId: contextId,
      priority: priority,
      created: created,
      state: state,
      notes: notes,
      tags: tags,
    );
  }
}
