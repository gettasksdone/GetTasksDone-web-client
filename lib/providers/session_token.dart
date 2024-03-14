import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gtd_client/utilities/constants.dart';

part 'session_token.g.dart';

@Riverpod(keepAlive: true)
class SessionToken extends _$SessionToken {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String key = 'session_token';

  String? _token;

  @override
  String? build() {
    if (testNavigation) {
      return 'session_token';
    }

    return _token;
  }

  static Future<String?> readFromStorage() async {
    if (await _storage.containsKey(key: key)) {
      return await _storage.read(key: key);
    }

    return null;
  }

  void set(String? token) async {
    _token = token;

    ref.invalidateSelf();

    if (token != null) {
      await _storage.write(key: key, value: token);
    } else {
      await _storage.delete(key: key);
    }
  }
}
