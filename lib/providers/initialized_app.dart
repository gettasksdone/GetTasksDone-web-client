import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initialized_app.g.dart';

@Riverpod(keepAlive: true)
class InitializedApp extends _$InitializedApp {
  bool _initialized = false;

  @override
  bool build() {
    return _initialized;
  }

  void done() {
    _initialized = true;

    ref.invalidateSelf();
  }

  void reset() {
    _initialized = false;

    ref.invalidateSelf();
  }
}
