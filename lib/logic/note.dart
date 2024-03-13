import 'package:gtd_client/mixins/serializable_mixin.dart';

class Note with SerializableMixin<Note> {
  static final Note instance = Note(content: '');

  final DateTime created;

  String content;

  Note({required this.content, DateTime? created})
      : created = created ?? DateTime.now();

  @override
  Map<int, Note> deserialize(Map<String, dynamic> data) {
    final Note note = Note(
      content: data['contenido'],
      created: data['creacion'],
    );

    return {data['id']: note};
  }
}
