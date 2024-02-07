import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account.g.dart';

@Riverpod(keepAlive: true)
class Account extends _$Account {
  String? _account;

  @override
  String? build() {
    return _account;
  }

  void set(String? email) {
    _account = email;

    ref.invalidateSelf();
  }
}
