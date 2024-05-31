import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/element_not_found_exception.dart';
import 'package:appium_flutter_server/src/internal/element_lookup_strategy.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/api/double_click.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uuid/uuid.dart';

enum NATIVE_ELEMENT_ATTRIBUTES { enabled, displayed, clickable }

class ElementHelper {
  static Future<Finder> findElement(Finder by, {String? contextId}) async {
    List<Finder> elementList = await findElements(by, contextId: contextId);
    log("Element found ${elementList.first}");
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
    await waitForElementExists(finder);
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

  static Future<void> click(FlutterElement element) async {
    WidgetTester tester = _getTester();
    await tester.tap(element.by);
    await tester.pumpAndSettle();
  }

  static Future<void> setText(FlutterElement element, String text) async {
    WidgetTester tester = _getTester();
    tester.testTextInput.register();
    await tester.enterText(element.by, text);
    await tester.pump(const Duration(milliseconds: 400));
  }

  static Future<void> gestureDoubleClick(
      DoubleClickModel doubleClickModel) async {
    final String? elementId = doubleClickModel.origin?.id;
    WidgetTester tester = _getTester();

    FlutterElement? element;
    if (elementId == null && doubleClickModel.locator != null) {
      element = FlutterElement(
          await locateElement(doubleClickModel.locator!), const Uuid().v4());
    } else if (elementId != null) {
      Session session = FlutterDriver.instance.getSessionOrThrow()!;
      element = await session.elementsCache.get(elementId);
    }

    if (element == null) {
      if (doubleClickModel.offset == null) {
        throw ArgumentError("Double click offset coordinates must be provided "
            "if element is not set");
      }

      await tester.tapAt(
          Offset(doubleClickModel.offset!.x, doubleClickModel.offset!.y));
    } else {
      if (doubleClickModel.offset == null) {
        await doubleClick(element);
      } else {
        Rect bounds = getElementBounds(element.by);
        log("Click by offset $bounds");
        await tester.tapAt(Offset(bounds.left + doubleClickModel.offset!.x,
            bounds.top + doubleClickModel.offset!.y));
        await tester.pump(kDoubleTapMinTime);
        await tester.tapAt(Offset(bounds.left + doubleClickModel.offset!.x,
            bounds.top + doubleClickModel.offset!.y));
        await tester.pumpAndSettle();
      }
    }
  }

  static Future<void> doubleClick(FlutterElement element) async {
    WidgetTester tester = _getTester();
    await tester.tap(element.by);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(element.by);
    await tester.pumpAndSettle();
  }

  static Future<String> getText(FlutterElement element) async {
    String getElementTextRecursively(Element element, {Set<Element>? visited}) {
      visited ??= <Element>{};

      if (visited.contains(element)) {
        return '';
      }
      visited.add(element);
      final StringBuffer buffer = StringBuffer();

      final widget = element.widget;
      if (widget is Text) {
        if (widget.data != null) {
          buffer.write(widget.data);
        } else if (widget.textSpan != null) {
          buffer.write(widget.textSpan!.toPlainText());
        }
      } else if (widget is RichText) {
        buffer.write(widget.text.toPlainText());
      } else if (widget is EditableText) {
        buffer.write(widget.controller.text);
      }

      if (element is RenderObjectElement) {
        element.visitChildren((child) {
          final childText = getElementTextRecursively(child, visited: visited);
          buffer.write(childText);
        });
      }

      return buffer.toString();
    }

    return getElementTextRecursively(element.by.evaluate().first);
  }

  static Future<dynamic> getAttribute(
      FlutterElement element, String attribute) async {
    if (NATIVE_ELEMENT_ATTRIBUTES.displayed.name == attribute) {
      return element.by.evaluate().isNotEmpty;
    } else if (NATIVE_ELEMENT_ATTRIBUTES.enabled.name == attribute) {
      return _isElementEnabled(element);
    } else if (NATIVE_ELEMENT_ATTRIBUTES.clickable.name == attribute) {
      return _isElementClickable(element);
    } else {
      DiagnosticsNode? property =
          _getElementPropertyNode(element.by, attribute);
      return property?.value.toString();
    }
  }

  static WidgetTester _getTester() {
    return FlutterDriver.instance.tester;
  }

  static Future<Finder> locateElement(FindElementModel model) async {
    final String method = model.strategy;
    final String selector = model.selector;
    final String? contextId = model.context == "" ? null : model.context;

    if (contextId == null) {
      log('"method: $method, selector: $selector');
    } else {
      log('"method: $method, selector: $selector, contextId: $contextId');
    }

    final Finder by = ElementLookupStrategy.values
        .firstWhere((val) => val.name == method)
        .toFinder(selector);
    return findElement(by, contextId: contextId);
  }

  static Rect getElementBounds(Finder by) {
    var tester = _getTester();
    return Rect.fromPoints(tester.getTopLeft(by), tester.getBottomRight(by));
  }

  static DiagnosticsNode? _getElementPropertyNode(Finder by, String propertry) {
    try {
      return FlutterDriver.instance.tester
          .widget(by)
          .toDiagnosticsNode()
          .getProperties()
          .where((node) => node.name == propertry)
          .first;
    } catch (e) {
      return null;
    }
  }

  static dynamic _isElementEnabled(FlutterElement element) {
    String attribute = NATIVE_ELEMENT_ATTRIBUTES.enabled.name;
    DiagnosticsNode? enabledProperty =
        _getElementPropertyNode(element.by, attribute);
    if (enabledProperty == null) {
      //For Button type elements, onPressed will be null if the element is disabled
      DiagnosticsNode? onPressed =
          _getElementPropertyNode(element.by, "onPressed");
      return (onPressed == null || onPressed.value == null) ? "false" : "true";
    } else {
      return enabledProperty.value.toString();
    }
  }

  static bool _isElementClickable(FlutterElement flutterElement) {
    /* 
     * Reference taken from https://github.com/flutter/flutter/blob/master/packages/flutter_test/lib/src/controller.dart#L1880
     * Method: _getElementPoint
     */
    TestAsyncUtils.guardSync();
    Finder finder = flutterElement.by;
    WidgetTester tester = _getTester();
    IntegrationTestWidgetsFlutterBinding binding =
        FlutterDriver.instance.binding;

    final Iterable<Element> elements = finder.evaluate();
    final Element element = elements.single;
    final RenderObject? renderObject = element.renderObject;
    if (renderObject == null) {
      log('The finder "$finder"  found an element, but it does not have a corresponding render object. '
          'Maybe the element has not yet been rendered?');
      return false;
    }
    if (renderObject is! RenderBox) {
      log('The finder "$finder"  found an element whose corresponding render object is not a RenderBox (it is a ${renderObject.runtimeType}: "$renderObject"). '
          'Unfortunately it only supports targeting widgets that correspond to RenderBox objects in the rendering.');
      return false;
    }
    final RenderBox box = element.renderObject! as RenderBox;
    final Offset location = box.localToGlobal(box.size.center(Offset.zero));
    final FlutterView view = tester.viewOf(finder);
    final HitTestResult result = HitTestResult();
    binding.hitTestInView(result, location, view.viewId);
    final bool found =
        result.path.any((HitTestEntry entry) => entry.target == box);
    if (!found) {
      return false;
    }
    return true;
  }

  static Future<void> waitForVisibility(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    return TestAsyncUtils.guard(() async {
      WidgetTester tester = _getTester();
      final end = tester.binding.clock.now().add(timeout);
      final hitTestableFinder = finder.hitTestable();
      while (hitTestableFinder.evaluate().isEmpty) {
        final now = tester.binding.clock.now();
        if (now.isAfter(end)) {
          break;
        }
        await tester.pump(const Duration(milliseconds: 100));
      }
    });
  }

  static Future<void> waitForElementExists(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    WidgetTester tester = _getTester();
    final end = tester.binding.clock.now().add(timeout);

    do {
      if (tester.binding.clock.now().isAfter(end)) {
        break;
      }

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 100));
    } while (finder.evaluate().isEmpty);
  }
}
