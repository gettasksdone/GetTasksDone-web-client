import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gtd_client/utilities/constants.dart';

part 'inbox_count.g.dart';

@Riverpod(keepAlive: true)
class InboxCount extends _$InboxCount {
  int _count = 0;

  @override
  int build() {
    if (testNavigation) {
      return 5;
    }

    return _count;
  }

  void set(int count) {
    _count = count;

    ref.invalidateSelf();
  }

  void addOne() {
    set(_count + 1);
  }

  void substractOne() {
    set(_count - 1);
  }
}
