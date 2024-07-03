import 'dart:collection';

class LRUCache<K, V> {
  final int _capacity;
  final Map<K, V> _cache = LinkedHashMap<K, V>();

  LRUCache(this._capacity);

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= _capacity) {
      var oldestKey = _cache.keys.first;
      _cache.remove(oldestKey);
    }
    _cache[key] = value;
  }

  V? get(K key) {
    if (_cache.containsKey(key)) {
      var value = _cache.remove(key)!;
      _cache[key] = value;
      return value;
    }
    return null;
  }
}
