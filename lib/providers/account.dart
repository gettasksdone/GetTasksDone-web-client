import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'account.g.dart';

@Riverpod(keepAlive: true)
class Account extends _$Account {
  String? _account;

  @override
  String? build() {
    if (kDebugMode) {
      return 'correo@correo.cor';
    }

    return _account;
  }

  void set(String? username) {
    _account = username;

    ref.invalidateSelf();
  }
}
