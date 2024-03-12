import 'package:gtd_client/logic/complex_element.dart';

class Task extends ComplexElement {
  final DateTime created = DateTime.now();
  final int id;

  DateTime? _expiration;
  String description;
  int contextId;
  String state;
  int priority;

  Task({
    required this.description,
    required this.contextId,
    required this.state,
    required this.priority,
    required this.id,
    List<int>? notes,
    List<int>? tags,
    DateTime? expiration,
  })  : _expiration = expiration,
        super(notes, tags) {
    if (_expiration != null) {
      assert(_expiration!.isAfter(created));
    }
  }

  DateTime? get expiration => _expiration;

  void setExpiration(DateTime? expiration) {
    _expiration = expiration;

    if (_expiration != null) {
      assert(_expiration!.isAfter(created));
    }
  }
}
