import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gtd_client/utilities/constants.dart';

part 'username.g.dart';

@Riverpod(keepAlive: true)
class Username extends _$Username {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String key = 'username';

  String? _username;

  @override
  String? build() {
    if (testNavigation) {
      return 'username';
    }

    return _username;
  }

  static Future<String?> readFromStorage() async {
    if (await _storage.containsKey(key: key)) {
      return await _storage.read(key: key);
    }

    return null;
  }

  void set(String? username) async {
    _username = username;

    ref.invalidateSelf();

    if (username != null) {
      await _storage.write(key: key, value: username);
    } else {
      await _storage.delete(key: key);
    }
  }
}
