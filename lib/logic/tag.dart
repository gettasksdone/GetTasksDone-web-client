import 'package:gtd_client/logic/serializable.dart';

class Tag extends Serializable<Tag> {
  static final Tag instance = Tag(id: -1, name: '');

  String name;

  Tag({required super.id, required this.name});

  @override
  Map<int, Tag> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: Tag(
        id: json['id'],
        name: json['nombre'],
      )
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {'nombre': name};
  }

  @override
  Tag withId(int id) {
    return Tag(id: id, name: name);
  }
}
