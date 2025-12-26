import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../local_storage_service.dart';

part 'shared_prefs_storage_service.g.dart';

class SharedPrefsStorageService implements LocalStorageService {
  final SharedPreferences _prefs;

  SharedPrefsStorageService(this._prefs);

  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}

@riverpod
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  throw UnimplementedError('Override this provider in ProviderScope');
}
