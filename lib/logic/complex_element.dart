class ComplexElement {
  final List<int> _notes;
  final List<int> _tags;

  ComplexElement(List<int>? notes, List<int>? tags)
      : _notes = notes ?? [],
        _tags = tags ?? [];

  List<int> get notes => _notes;
  List<int> get tags => _tags;

  void addNote(int note) {
    _notes.add(note);
  }

  void addTag(int tag) {
    _tags.add(tag);
  }

  void removeNote(int note) {
    _notes.remove(note);
  }

  void removeTag(int tag) {
    _tags.remove(tag);
  }
}
