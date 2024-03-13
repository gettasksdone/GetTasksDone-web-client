import 'package:gtd_client/mixins/serializable_mixin.dart';

class CheckItem with SerializableMixin<CheckItem> {
  static final CheckItem instance = CheckItem(content: '');

  String content;
  bool checked;

  CheckItem({required this.content, bool? checked})
      : checked = checked ?? false;

  @override
  Map<int, CheckItem> deserialize(Map<String, dynamic> data) {
    final CheckItem checkItem = CheckItem(
      checked: data['esta_marcado'],
      content: data['contenido'],
    );

    return {data['id']: checkItem};
  }
}
