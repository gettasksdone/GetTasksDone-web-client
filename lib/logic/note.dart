import 'package:gtd_client/logic/base_item.dart';

class Note extends BaseItem<Note> {
  static final Note instance = Note();

  final DateTime created;

  String? content;

  Note({super.id, this.content, DateTime? created})
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
    assert(content != null);

    return {
      'contenido': content,
      'creacion': created,
    };
  }
}
