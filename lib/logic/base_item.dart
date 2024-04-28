import 'dart:convert';

abstract class BaseItem<T> {
  int _id;

  BaseItem({int id = -1}) : _id = id;

  int get id => _id;

  void setId(int id) {
    assert(_id == -1);

    _id = id;
  }

  T copy();

  Map<int, T> decodeList(String body) {
    return fromJsonList(jsonDecode(body) as List<dynamic>);
  }

  Map<int, T> fromJsonList(List<dynamic> json) {
    final Map<int, T> elements = {};

    for (final Map<String, dynamic> elementData in json) {
      elements.addAll(fromJson(elementData));
    }

    return elements;
  }

  Map<int, T> decode(String body) {
    return fromJson(jsonDecode(body) as Map<String, dynamic>);
  }

  Map<int, T> fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
