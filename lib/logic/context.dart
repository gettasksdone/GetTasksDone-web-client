import 'package:gtd_client/logic/serializable.dart';

class Context extends Serializable<Context> {
  static final Context instance = Context(id: -1, name: '');

  String name;

  Context({required super.id, required this.name});

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
    return {'nombre': name};
  }

  @override
  Context withId(int id) {
    return Context(id: id, name: name);
  }
}
