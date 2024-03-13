import 'package:gtd_client/mixins/serializable_mixin.dart';

class Tag with SerializableMixin<String> {
  static final Tag instance = Tag();

  @override
  Map<int, String> deserialize(Map<String, dynamic> data) {
    return {data['id']: data['nombre']};
  }
}
