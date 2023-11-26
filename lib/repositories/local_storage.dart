
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final _singleton = LocalStorage._internal();

  factory LocalStorage() => _singleton;
  late SharedPreferences _prefs;

  LocalStorage._internal();

  bool get hasToken => token.isNotEmpty;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get token => _prefs.getString('token') ?? '';

  Future<bool> setToken(String token) async {
    return _prefs.setString('token', token);
  }

  Future<bool> removeToken() async {
    return _prefs.remove('token');
  }

  String get refreshToken => _prefs.getString('refreshToken') ?? '';

  Future<bool> setRefreshToken(String token) async {
    return _prefs.setString('refreshToken', token);
  }

  Future<bool> removeRefreshToken() async {
    return _prefs.remove('refreshToken');
  }

  String get fmsToken => _prefs.getString('fmsToken') ?? '';

  Future<bool> setFmsToken(String fmsToken) async {
    return _prefs.setString('fmsToken', fmsToken);
  }

  Future<bool> removeFmsToken() async {
    return _prefs.remove('fmsToken');
  }

  String? get currentLocale => _prefs.getString('currentLocale');

  Future<bool> setCurrentLocale(String currentLocale) async {
    return _prefs.setString('currentLocale', currentLocale);
  }

  Future<bool> removeCurrentLocale() async {
    return _prefs.remove('currentLocale');
  }

  String get currentUser => _prefs.getString('currentUser') ?? '';

  Future<bool> setCurrentUser(String currentUser) async {
    return _prefs.setString('currentUser', currentUser);
  }

  Future<bool> removeCurrentUser() async {
    return _prefs.remove('currentUser');
  }
}
