import 'dart:convert';

abstract mixin class SerializableMixin<T> {
  Map<int, T> parseList(String body) {
    return deserializeList(jsonDecode(body));
  }

  Map<int, T> deserializeList(List<Map<String, dynamic>> data) {
    final Map<int, T> elements = {};

    for (Map<String, dynamic> elementData in data) {
      elements.addAll(deserialize(elementData));
    }

    return elements;
  }

  Map<int, T> parse(String body) {
    return deserialize(jsonDecode(body));
  }

  Map<int, T> deserialize(Map<String, dynamic> data);
}
