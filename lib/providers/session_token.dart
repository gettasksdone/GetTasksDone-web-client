import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'session_token.g.dart';

@Riverpod(keepAlive: true)
class SessionToken extends _$SessionToken {
  String? _token;

  @override
  String? build() {
    if (kDebugMode) {
      return 'session_token';
    }

    return _token;
  }

  void set(String token) {
    _token = token;

    ref.invalidateSelf();
  }
}
