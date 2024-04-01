import 'package:gtd_client/logic/base_item.dart';

abstract class ComplexItem<T> extends BaseItem<T> {
  final Set<int> _notes;
  final Set<int> _tags;

  ComplexItem({super.id, Set<int>? notes, Set<int>? tags})
      : _notes = notes ?? {},
        _tags = tags ?? {};

  Set<int> get notes => _notes;
  Set<int> get tags => _tags;

  void addNote(int id) {
    _notes.add(id);
  }

  void addTag(int id) {
    _tags.add(id);
  }

  void removeNote(int id) {
    _notes.remove(id);
  }

  void removeTag(int id) {
    _tags.remove(id);
  }
}
