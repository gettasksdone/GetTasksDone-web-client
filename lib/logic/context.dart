import 'package:gtd_client/logic/base_item.dart';

class Context extends BaseItem<Context> {
  static final Context instance = Context();

  String? name;

  Context({super.id, this.name});

  @override
  Map<int, Context> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: Context(
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
