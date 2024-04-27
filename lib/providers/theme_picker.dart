import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'theme_picker.g.dart';

@Riverpod(keepAlive: true)
class ThemePicker extends _$ThemePicker {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;

  @override
  ThemeMode build() {
    return _mode;
  }

  String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  ThemeMode _fromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> initialize() async {
    if (await _storage.containsKey(key: _key)) {
      _mode = _fromString((await _storage.read(key: _key))!);

      ref.invalidateSelf();
    }
  }

  void set(ThemeMode mode) {
    _mode = mode;

    _storage.write(key: _key, value: _toString(mode));

    ref.invalidateSelf();
  }
}
