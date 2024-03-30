import 'package:flutter/material.dart';

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  DateTime? finishDate,
  DateTime? startDate,
}) async {
  late final DateTime initialDate;

  if (finishDate != null) {
    startDate = finishDate.subtract(const Duration(days: 3650));
    initialDate = finishDate;
  } else {
    finishDate = startDate!.add(const Duration(days: 3650));
    initialDate = startDate;
  }

  return await showDatePicker(
    context: context,
    firstDate: startDate,
    lastDate: finishDate,
    initialDate: initialDate,
  );
}
