import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class BackendConfiguration {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final BackendConfiguration _instance =
      BackendConfiguration._backendConfiguration();
  static const String _selectedUrlKey = 'selected_backend_url';
  static const String _urlsKey = 'backend_urls';

  Set<String>? _urls;
  String? _url;

  BackendConfiguration._backendConfiguration();

  factory BackendConfiguration() {
    return _instance;
  }

  Set<String> get urls => _urls!;
  String get url => _url!;

  Future<void> initialize() async {
    assert(_urls == null);
    assert(_url == null);

    if (await _storage.containsKey(key: _selectedUrlKey)) {
      _url = await _storage.read(key: _selectedUrlKey);
    } else {
      _url = 'https://lopezgeraghty.com:8080';
    }

    if (await _storage.containsKey(key: _urlsKey)) {
      _urls = List<String>.from(
        jsonDecode((await _storage.read(key: _urlsKey))!),
      ).toSet();
    } else {
      _urls = {_url!};
    }
  }

  void set(String url) {
    assert(_urls != null);
    assert(_url != null);

    _url = url;

    _urls!.add(url);

    _storage.write(key: _selectedUrlKey, value: url);
    _storage.write(key: _urlsKey, value: jsonEncode(_urls!.toList()));
  }
}
