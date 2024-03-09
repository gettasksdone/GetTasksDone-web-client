import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

part 'completed_registry.g.dart';

@Riverpod(keepAlive: true)
class CompletedRegistry extends _$CompletedRegistry {
  bool _completed = false;

  @override
  bool build() {
    if (kDebugMode) {
      return true;
    }

    return _completed;
  }

  void set(bool completed) {
    _completed = completed;

    ref.invalidateSelf();
  }
}
