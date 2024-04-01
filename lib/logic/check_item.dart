import 'package:gtd_client/logic/base_item.dart';

class CheckItem extends BaseItem<CheckItem> {
  static final CheckItem instance = CheckItem();

  String? content;
  bool checked;

  CheckItem({super.id, this.content, this.checked = false});

  @override
  Map<int, CheckItem> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: CheckItem(
        id: json['id'],
        checked: json['esta_marcado'],
        content: json['contenido'],
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    assert(content != null);

    return {
      'esta_marcado': checked,
      'contenido': content,
    };
  }
}
