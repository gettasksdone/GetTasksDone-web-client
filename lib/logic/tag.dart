import 'package:gtd_client/logic/base_item.dart';

class Tag extends BaseItem<Tag> {
  static final Tag instance = Tag();

  String? name;

  Tag({super.id, this.name});

  @override
  Tag copy() {
    return Tag(id: id, name: name);
  }

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
    assert(name != null);

    return {'nombre': name};
  }
}
