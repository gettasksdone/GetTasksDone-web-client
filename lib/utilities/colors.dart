import 'package:flutter/material.dart';
import 'dart:math';

final Random _random = Random();

Color getRandomColor() {
  return Colors.primaries[_random.nextInt(Colors.primaries.length)];
}
