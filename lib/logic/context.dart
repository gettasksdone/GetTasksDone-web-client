import 'package:gtd_client/mixins/serializable_mixin.dart';

class Context with SerializableMixin<String> {
  static final Context instance = Context();

  @override
  Map<int, String> deserialize(Map<String, dynamic> data) {
    return {data['id']: data['nombre']};
  }
}
