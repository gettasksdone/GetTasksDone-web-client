class Note {
  final DateTime created = DateTime.now();
  final int id;

  String content;

  Note({required this.content, required this.id});
}
