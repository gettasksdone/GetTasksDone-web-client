import 'package:gtd_client/mixins/serializable_mixin.dart';
import 'package:gtd_client/logic/complex_element.dart';
import 'package:gtd_client/logic/check_item.dart';
import 'package:gtd_client/logic/context.dart';
import 'package:gtd_client/logic/note.dart';
import 'package:gtd_client/logic/tag.dart';

class Task extends ComplexElement with SerializableMixin<Task> {
  static final Task instance = Task(
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
    required this.description,
    required this.contextId,
    required this.priority,
    required this.state,
    List<int>? checkItems,
    DateTime? expiration,
    DateTime? created,
    List<int>? notes,
    List<int>? tags,
  })  : created = created ?? DateTime.now(),
        _checkItems = checkItems ?? [],
        _expiration = expiration,
        super(notes, tags) {
    if (_expiration != null) {
      assert(_expiration!.isAfter(this.created));
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
  Map<int, Task> deserialize(Map<String, dynamic> data) {
    final Task task = Task(
      expiration: data.containsKey('vencimiento')
          ? DateTime.parse(data['vencimiento'])
          : null,
      checkItems:
          CheckItem.instance.deserializeList(data['checkItems']).keys.toList(),
      contextId: Context.instance.deserialize(data['contexto']).keys.first,
      tags: Tag.instance.deserializeList(data['etiquetas']).keys.toList(),
      notes: Note.instance.deserializeList(data['notas']).keys.toList(),
      created: DateTime.parse(data['creacion']),
      description: data['descripcion'],
      priority: data['prioridad'],
      state: data['estado'],
    );

    return {data['id']: task};
  }
}
