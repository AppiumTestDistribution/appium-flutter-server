import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synchronized/extension.dart';
import 'package:uuid/uuid.dart';

class ElementsCache {
  Map<String, FlutterElement> cache = new Map();

  Future<FlutterElement> get(String id) {
    return synchronized(() {
      return cache[id]!;
    });
  }

  Future<FlutterElement> add(Finder by,
      {bool isSingle = true, String? contextId}) {
    return synchronized(() {
      FlutterElement flutterElement =
          FlutterElement.childElement(by, Uuid().v4(), contextId);
      cache.putIfAbsent(flutterElement.id, () => flutterElement);
      return flutterElement;
    });
  }
}
