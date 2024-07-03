import 'dart:convert';

import 'package:appium_flutter_server/src/exceptions/element_not_found_exception.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/internal/widget_predicates.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class FlutterFinderStrategy {
  static Future<FlutterElement> findElement(String elementId) async {
    try {
      Map<String, dynamic> strategy = _decodeElementStrategy(elementId);
      return _locateElement(strategy);
    } catch (e) {
      log(e.toString());
      log(e);
      throw ElementNotFoundException("Element not found");
    }
  }

  static Map<String, dynamic> _decodeElementStrategy(String elementId) {
    String jsonString = utf8.decode(base64.decode(base64.normalize(elementId)));
    return json.decode(jsonString);
  }

  static Future<FlutterElement> _locateElement(Map<String, dynamic> strategy,
      {bool ensureElementPresent = true}) async {
    Finder? by;
    switch (strategy['finderType']) {
      case "ByValueKey":
        by = _byValueKey(strategy);
        break;
      case "ByTooltipMessage":
        by = _byToolTip(strategy);
        break;
      case "BySemanticsLabel":
        by = _bySemanticsLabel(strategy);
        break;
      case "ByType":
        by = _byType(strategy);
        break;
      case "ByText":
        by = _byText(strategy);
        break;
      case "Ancestor":
        by = await _byAncestor(strategy);
        break;
      case "Descendant":
        by = await _byDescendant(strategy);
        break;
    }

    log("Finder By $by");
    if (by == null || (ensureElementPresent && by.evaluate().isEmpty)) {
      throw ElementNotFoundException(
          "Unable to locate element with strategy: ${strategy['finderType']}");
    }

    return FlutterElement.fromBy(ensureElementPresent ? by.at(0) : by);
  }

  static Finder? _byValueKey(Map<String, dynamic> strategy) {
    if (strategy['keyValueString'] != null) {
      return find.byKey(Key(strategy['keyValueString']));
    }
    return null;
  }

  static Finder? _byToolTip(Map<String, dynamic> strategy) {
    if (strategy['text'] != null) {
      return find.byTooltip(strategy['text']);
    }
    return null;
  }

  static Finder? _bySemanticsLabel(Map<String, dynamic> strategy) {
    if (strategy['label'] != null) {
      return find.bySemanticsLabel(strategy['label']);
    }
    return null;
  }

  static Finder? _byType(Map<String, dynamic> strategy) {
    if (strategy['type'] != null) {
      return find.byWidgetPredicate(filterByWidgetName(strategy['type']));
    }
    return null;
  }

  static Finder? _byText(Map<String, dynamic> strategy) {
    if (strategy['text'] != null) {
      return find.byType(strategy['text']);
    }
    return null;
  }

  static Future<Finder?> _byAncestor(Map<String, dynamic> strategy) async {
    if (strategy['of'] != null && strategy['matching'] != null) {
      var of = await _locateElement(jsonDecode(strategy['of']));
      var matching = await _locateElement(jsonDecode(strategy["matching"]),
          ensureElementPresent: false);
      var matchRoot = strategy['matchRoot'] == null
          ? false
          : bool.parse(strategy['matchRoot']);

      return find.ancestor(
          of: of.by, matching: matching.by, matchRoot: matchRoot);
    }
    return null;
  }

  static Future<Finder?> _byDescendant(Map<String, dynamic> strategy) async {
    if (strategy['of'] != null && strategy['matching'] != null) {
      var of = await _locateElement(jsonDecode(strategy['of']));
      var matching = await _locateElement(jsonDecode(strategy["matching"]),
          ensureElementPresent: false);
      var matchRoot = strategy['matchRoot'] == null
          ? false
          : bool.parse(strategy['matchRoot']);

      return find.descendant(
          of: of.by, matching: matching.by, matchRoot: matchRoot);
    }
    return null;
  }
}
