import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final _storage = SharedPreferences.getInstance();

  Future<String> readString({required String key}) async {
    final readData = (await _storage).getString(key) ?? '';
    return readData;
  }

  Future<void> saveString({required String key, required String value}) async {
    await (await _storage).setString(key, value);
  }

  Future<List<String>> readStringList({required String key}) async {
    final readData = (await _storage).getStringList(key) ?? [];
    return readData;
  }

  Future<void> saveStringList({required String key, required List<String> value}) async {
    await (await _storage).setStringList(key, value);
  }

  Future<void> removeKey({required String key}) async => (await _storage).remove(key);

  Future<void> removeAllKey() async => (await _storage).clear();
}
