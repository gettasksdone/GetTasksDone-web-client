import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_token.g.dart';

@Riverpod(keepAlive: true)
class SessionToken extends _$SessionToken {
  String? _token;

  @override
  String? build() {
    return _token;
  }

  void set(String token) {
    _token = token;

    ref.invalidateSelf();
  }
}
