import 'dart:math';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/element_not_found_exception.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class ElementHelper {
  static Future<Finder> findElement(Finder by, {String? contextId}) async {
    List<Finder> elementList = await findElements(by, contextId: contextId);
    return elementList.first;
  }

  static Future<List<Finder>> findElements(Finder by,
      {String? contextId}) async {
    Session? session = FlutterDriver.instance.getSessionOrThrow();
    WidgetTester tester = FlutterDriver.instance.tester;
    Finder finder = by;

    if (contextId != null) {
      FlutterElement? parent = await FlutterDriver.instance
          .getSessionOrThrow()!
          .elementsCache
          .get(contextId);

      finder = find.descendant(of: parent.by, matching: by);
    }

    final Iterable<Element> elements = finder.evaluate();
    if (elements.isEmpty) {
      throw ElementNotFoundException("Unable to locate element");
    }

    List<Finder> elementList = [];
    for (int i = 0; i < elements.length; i++) {
      elementList.add(finder.at(i));
    }
    return elementList;
  }
}
