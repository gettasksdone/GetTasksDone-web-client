import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gtd_client/utilities/constants.dart';

part 'new_user.g.dart';

@Riverpod(keepAlive: true)
class NewUser extends _$NewUser {
  bool _new = false;

  @override
  bool build() {
    if (testNavigation) {
      return true;
    }

    return _new;
  }

  void set(bool isNewUser) {
    _new = isNewUser;

    ref.invalidateSelf();
  }
}
