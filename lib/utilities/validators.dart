import 'dart:ui';

String? notEmptyValidator(String? input, VoidCallback onValid) {
  if (input == null || input.isEmpty) {
    return 'Rellene este campo';
  }

  onValid();

  return null;
}
