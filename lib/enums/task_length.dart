enum TaskLength {
  minutes15(text: "15 MIN"),
  minutes30(text: "30 MIN"),
  hours1(text: "1 HORA"),
  hours2(text: "2 HORAS"),
  hours3(text: "3 HORAS");

  const TaskLength({required this.text});

  final String text;
}
