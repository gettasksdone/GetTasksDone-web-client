import 'package:gtd_client/logic/serializable.dart';

class Note extends Serializable<Note> {
  static final Note instance = Note(content: '');

  final DateTime created;

  String content;

  Note({required this.content, DateTime? created})
      : created = created ?? DateTime.now();

  @override
  Map<int, Note> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: Note(
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
}
