import 'dart:convert';

abstract class Serializable<T> {
  const Serializable();

  Map<int, T> decodeList(String body) {
    return fromJsonList(jsonDecode(body) as List<dynamic>);
  }

  Map<int, T> fromJsonList(List<dynamic> json) {
    final Map<int, T> elements = {};

    for (Map<String, dynamic> elementData in json) {
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
