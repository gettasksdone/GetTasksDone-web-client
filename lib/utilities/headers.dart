import 'package:gtd_client/providers/session_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Map<String, String> contentType = {
  'Content-Type': 'application/json; charset=UTF-8',
};

Map<String, String> headers(WidgetRef ref) {
  return {
    'Authorization': 'Bearer ${ref.watch(sessionTokenProvider)}',
  }..addAll(contentType);
}
