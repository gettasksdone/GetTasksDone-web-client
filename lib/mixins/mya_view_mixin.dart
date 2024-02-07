import 'package:blackforesttools/utilities/enums.dart';
import 'package:flutter/material.dart';

mixin MYAViewMixin<T extends StatefulWidget> on State<T> {
  static const String myaTitle = 'M A C R O   Y O U T U B E   A N A L Y S I S';
  static const String myaEndpoint = 'mya';

  late final int _mode;

  int? selectedCategory;
  int? checkAmount;

  Map<String, dynamic> get payload => {
        'mode': _mode,
        'category': selectedCategory,
        'check_amount': checkAmount,
      };

  void myaViewMixin(MYAModes mode) {
    _mode = mode.index;

    if (mode == MYAModes.random) {
      selectedCategory = 0;
      checkAmount = 1;
    }
  }
}
