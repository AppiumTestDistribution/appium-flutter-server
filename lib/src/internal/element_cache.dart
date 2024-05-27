import 'package:appium_flutter_server/src/exceptions/stale_element_reference_exception.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/internal/flutter_finder_strategy.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synchronized/extension.dart';
import 'package:uuid/uuid.dart';

class ElementsCache {
  Map<String, FlutterElement> cache = {};

  Future<FlutterElement> get(String id) async {
    return synchronized(() async {
      FlutterElement? element = cache[id];
      if (element == null) {
        try {
          element = await FlutterFinderStrategy.findElement(id);
        } catch (e) {
          log("Element $id not found in cache");
          throw StaleElementReferenceException(
              "The element '$id' does not exist in DOM anymore");
        }
      } else {
        Iterable<Element> foundElement = element.by.evaluate();
        log("Element $id is not found in DOM");
        if (foundElement.isEmpty) {
          throw StaleElementReferenceException(
              "The element '$id' does not exist in DOM anymore");
        }
      }
      return element;
    });
  }

  Future<FlutterElement> add(Finder by,
      {bool isSingle = true, String? contextId}) {
    return synchronized(() {
      FlutterElement flutterElement =
          FlutterElement.childElement(by, const Uuid().v4(), contextId);
      cache[flutterElement.id] = flutterElement;
      return flutterElement;
    });
  }
}
