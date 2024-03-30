import 'dart:ui';

String? notEmptyValidator(
  String? input,
  String errorMessage,
  VoidCallback onValid,
) {
  if (input == null || input.isEmpty) {
    return errorMessage;
  }

  onValid();

  return null;
}
