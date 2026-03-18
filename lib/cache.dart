// Cache Store
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheStore {
  final SharedPreferences _prefs;

  CacheStore(this._prefs);

  /// Saves a string value to local storage
  Future<void> save({required String key, required String value}) async {
    await _prefs.setString(key, value);
  }

  /// Reads a string value from local storage. Returns null if not found.
  Future<String?> read({required String key}) async {
    return _prefs.getString(key);
  }

  /// Wipes all data in the SharedPreferences store
  Future<void> clean() async {
    await _prefs.clear();
  }

  /// Remove just a specific key
  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }
}

// cacheStore Provider
final cacheStoreProvider = FutureProvider<CacheStore>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return CacheStore(prefs);
});