import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BackendConfiguration {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final BackendConfiguration _instance =
      BackendConfiguration._backendConfiguration();
  static const String _key = 'backend_url';

  String? _url;

  BackendConfiguration._backendConfiguration();

  factory BackendConfiguration() {
    return _instance;
  }

  String get url => _url!;

  Future<void> initialize() async {
    assert(_url == null);

    if (await _storage.containsKey(key: _key)) {
      _url = await _storage.read(key: _key);
    } else {
      _url = 'https://lopezgeraghty.com:8080';
    }
  }

  void set(String url) {
    _url = url;

    _storage.write(key: _key, value: url);
  }
}
