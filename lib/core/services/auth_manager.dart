import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  final SharedPreferences _prefs;
  static const _tokenKey = 'auth_token';

  AuthManager(this._prefs);

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    await _prefs.remove(_tokenKey);
  }
}