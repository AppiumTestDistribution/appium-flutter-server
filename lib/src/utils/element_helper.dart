import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/no_driver_exception.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class ElementHelper {
  static Future<Finder> findElement(Finder by, {String? contextId}) async {
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

    final Iterable<Element> element = finder.evaluate();
    if (element.isEmpty) {
      throw NoSuchDriverException("");
    }

    return finder.at(0);
  }

  // Future<Element> _findElementFromContext(
  //     Finder by, Session session, WidgetTester tester, String contextId) async {
  //   return null;
  // }
}
