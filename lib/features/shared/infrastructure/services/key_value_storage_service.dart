abstract class KeyValueStorageService {
  //T mando el tipo de dato, generico
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);
}
