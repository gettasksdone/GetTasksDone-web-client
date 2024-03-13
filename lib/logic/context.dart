import 'package:gtd_client/logic/serializable.dart';

class Context extends Serializable<Context> {
  static final Context instance = Context(name: '');

  String name;

  Context({required this.name});

  @override
  Map<int, Context> fromJson(Map<String, dynamic> json) {
    return {json['id']: Context(name: json['nombre'])};
  }

  @override
  Map<String, dynamic> toJson() {
    return {'nombre': name};
  }
}
