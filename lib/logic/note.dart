import 'package:gtd_client/logic/serializable.dart';

class Note extends Serializable<Note> {
  static final Note instance = Note(id: -1, content: '');

  final DateTime created;

  String content;

  Note({required super.id, required this.content, DateTime? created})
      : created = created ?? DateTime.now();

  @override
  Map<int, Note> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: Note(
        id: json['id'],
        content: json['contenido'],
        created: json['creacion'],
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'contenido': content,
      'creacion': created,
    };
  }

  @override
  Note withId(int id) {
    return Note(id: id, content: content, created: created);
  }
}
