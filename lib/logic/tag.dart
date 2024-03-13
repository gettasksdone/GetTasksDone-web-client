import 'package:gtd_client/logic/serializable.dart';

class Tag extends Serializable<Tag> {
  static final Tag instance = Tag(name: '');

  String name;

  Tag({required this.name});

  @override
  Map<int, Tag> fromJson(Map<String, dynamic> json) {
    return {json['id']: Tag(name: json['nombre'])};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'nombre': name};
  }
}
