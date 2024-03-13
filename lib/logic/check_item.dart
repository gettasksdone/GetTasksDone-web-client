import 'package:gtd_client/logic/serializable.dart';

class CheckItem extends Serializable<CheckItem> {
  static final CheckItem instance = CheckItem(content: '');

  String content;
  bool checked;

  CheckItem({required this.content, bool? checked})
      : checked = checked ?? false;

  @override
  Map<int, CheckItem> fromJson(Map<String, dynamic> json) {
    return {
      json['id']: CheckItem(
        checked: json['esta_marcado'],
        content: json['contenido'],
      ),
    };
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'esta_marcado': checked,
      'contenido': content,
    };
  }
}
