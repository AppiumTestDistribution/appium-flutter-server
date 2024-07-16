import 'dart:io';

import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/element_not_found_exception.dart';
import 'package:appium_flutter_server/src/exceptions/flutter_automation_error.dart';
import 'package:appium_flutter_server/src/internal/element_lookup_strategy.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/api/drag_drop.dart';
import 'package:appium_flutter_server/src/models/api/gesture.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

enum NATIVE_ELEMENT_ATTRIBUTES { enabled, displayed, clickable }

typedef WaitPredicate = Future<bool> Function();

/// Default amount to drag by when scrolling.
const defaultScrollDelta = 64.0;

/// Default maximum number of drags during scrolling.
const defaultScrollMaxIteration = 15;

const Duration defaultWaitTimeout = Duration(seconds: 5);

class ElementHelper {
  static Future<Finder> findElement(Finder by, {String? contextId}) async {
    List<Finder> elementList =
        await findElements(by, contextId: contextId, evaluatePresence: true);
    log("Element found ${elementList.first}");
    return elementList.first;
  }

  static Future<List<Finder>> findElements(Finder by,
      {String? contextId, bool evaluatePresence = false}) async {
    Finder finder = by;

    if (contextId != null) {
      FlutterElement? parent = await FlutterDriver.instance
          .getSessionOrThrow()!
          .elementsCache
          .get(contextId);

      finder = find.descendant(of: parent.by, matching: by);
    }
    finder = finder.hitTestable();
    final FinderResult<Element> elements = finder.evaluate();
    if (evaluatePresence) {
      await waitForElementExist(FlutterElement.fromBy(finder),
          timeout: defaultWaitTimeout);

      if (elements.isEmpty) {
        throw ElementNotFoundException("Unable to locate element");
      }
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
    await pumpAndTrySettle();
  }

  static Future<void> setText(FlutterElement element, String text) async {
    WidgetTester tester = _getTester();
    await tester.enterText(element.by, text);
    await tester.pump(const Duration(milliseconds: 400));
  }

  static Future<void> gestureDoubleClick(GestureModel doubleClickModel) async {
    await TestAsyncUtils.guard(() async {
      final String? elementId = doubleClickModel.origin?.id;
      WidgetTester tester = _getTester();

      FlutterElement? element;
      if (elementId == null && doubleClickModel.locator != null) {
        Finder by = await locateElement(doubleClickModel.locator!);
        element = FlutterElement.fromBy(by);
      } else if (elementId != null) {
        Session session = FlutterDriver.instance.getSessionOrThrow()!;
        element = await session.elementsCache.get(elementId);
      }

      if (element == null) {
        if (doubleClickModel.offset == null) {
          throw ArgumentError(
              "Double click offset coordinates must be provided "
              "if element is not set");
        }

        await tester.tapAt(
            Offset(doubleClickModel.offset!.x, doubleClickModel.offset!.y));
      } else {
        if (doubleClickModel.offset == null) {
          await doubleClick(element);
        } else {
          Rect bounds = getElementBounds(element!.by);
          log("Click by offset $bounds");
          await tester.tapAt(Offset(bounds.left + doubleClickModel.offset!.x,
              bounds.top + doubleClickModel.offset!.y));
          await tester.pump(kDoubleTapMinTime);
          await tester.tapAt(Offset(bounds.left + doubleClickModel.offset!.x,
              bounds.top + doubleClickModel.offset!.y));
          await pumpAndTrySettle();
        }
      }
    });
  }

  static Future<void> doubleClick(FlutterElement element) async {
    WidgetTester tester = _getTester();
    await tester.tap(element.by);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(element.by);
    await pumpAndTrySettle();
  }

  static Future<void> longPress(GestureModel longPressModel) async {
    return TestAsyncUtils.guard(() async {
      final String? elementId = longPressModel.origin?.id;
      WidgetTester tester = _getTester();

      FlutterElement? element;
      if (elementId == null && longPressModel.locator != null) {
        Finder by = await locateElement(longPressModel.locator!);
        element = FlutterElement.fromBy(by);
      } else if (elementId != null) {
        Session session = FlutterDriver.instance.getSessionOrThrow()!;
        element = await session.elementsCache.get(elementId);
      }
      if (element == null) {
        if (longPressModel.offset == null) {
          throw ArgumentError("LongPress offset coordinates must be provided "
              "if element is not set");
        }

        await tester.longPressAt(
            Offset(longPressModel.offset!.x, longPressModel.offset!.y));
      } else {
        if (longPressModel.offset == null) {
          await tester.longPress(element.by);
        } else {
          Rect bounds = getElementBounds(element!.by);
          log("Click by offset $bounds");
          await tester.longPressAt(
              Offset(longPressModel.offset!.x, longPressModel.offset!.y));
          await pumpAndTrySettle();
        }
      }
    });
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
      List<DiagnosticsNode> nodes = FlutterDriver.instance.tester
          .widget(element.by)
          .toDiagnosticsNode()
          .getProperties();
      List<DiagnosticsNode> data = [];
      try {
        data = FlutterDriver.instance.tester
            .getSemantics(element.by)
            .toDiagnosticsNode()
            .getChildren()
            .first
            .getProperties();
        FlutterDriver.instance.tester
            .getSemantics(element.by)
            .getSemanticsData()
            .toDiagnosticsNode()
            .getProperties()
            .forEach((element) {
          log("Semantics data : ${element.name} -> ${element.value}");
        });
      } catch (err) {
        log(err);
      }
      data.addAll(nodes);
      log("Available attributes for the element : ${element.by}");
      for (DiagnosticsNode node in nodes) {
        log("${node.name} -> ${node.value}");
      }
      log("Attribute in else block");
      log(data);
      try {
        if (attribute == "all") {
          Map<String, dynamic> values = {};
          for (DiagnosticsNode node in data) {
            log("${node.name.toString()} -> ${node.value.toString()}");
            var value = node.name.toString();
            values[value] = node.value.toString();
          }
          return values;
        } else {
          return data
              .firstWhere((node) => node.name == attribute)
              .value
              .toString();
        }
      } catch (err) {
        log(err);
        return null;
      }
    }
  }

  static WidgetTester _getTester() {
    return FlutterDriver.instance.tester;
  }

  static Future<Finder> locateElement(FindElementModel model,
      {bool evaluatePresence = true}) async {
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
    if (evaluatePresence) {
      return await findElement(by, contextId: contextId);
    } else {
      return by;
    }
  }

  static Rect getElementBounds(Finder by) {
    var tester = _getTester();
    return Rect.fromPoints(tester.getTopLeft(by), tester.getBottomRight(by));
  }

  static Size getElementSize(Finder by) {
    var tester = _getTester();
    return tester.getSize(by);
  }

  static String getElementName(Finder by) {
    var tester = _getTester();
    Element element = tester.element(by);
    if (element is RenderObjectElement &&
        element.renderObject.debugSemantics?.label != null) {
      final String? semanticsLabel = element.renderObject.debugSemantics?.label;
      if (semanticsLabel != null) {
        return semanticsLabel.toString();
      }
    }
    return element.widget.runtimeType.toString();
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

  static Future<void> waitForElementExist(FlutterElement element,
      {required Duration timeout}) async {
    await waitFor(() async {
      try {
        return element.by.evaluate().isNotEmpty;
      } catch (e) {
        return false;
      }
    },
        timeout: timeout,
        errorMessage:
            "Element with locator ${element.by.describeMatch(Plurality.one)} is not present in DOM");
  }

  static Future<void> waitForElementVisible(FlutterElement element,
      {required Duration timeout}) async {
    await waitFor(() async {
      try {
        return element.by.hitTestable().evaluate().isNotEmpty;
      } catch (e) {
        return false;
      }
    },
        timeout: timeout,
        errorMessage:
            "Element with locator ${element.by.describeMatch(Plurality.one)} is not visible");
  }

  static Future<void> waitForElementAbsent(FlutterElement element,
      {required Duration timeout}) async {
    await waitFor(
      () async {
        try {
          return element.by.evaluate().isEmpty;
        } catch (e) {
          return true;
        }
      },
      timeout: timeout,
      errorMessage:
          "Element with locator ${element.by.describeMatch(Plurality.one)} not visible",
    );
  }

  static Future<void> waitForElementEnable(FlutterElement element) async {
    await waitFor(() async {
      return bool.parse(await ElementHelper.getAttribute(
          element, NATIVE_ELEMENT_ATTRIBUTES.enabled.name));
    },
        errorMessage:
            "Element with locator ${element.by.describeMatch(Plurality.one)} not enabled");
  }

  static Future<void> waitForElementClickable(FlutterElement element) async {
    await waitFor(() async {
      return bool.parse(await ElementHelper.getAttribute(
          element, NATIVE_ELEMENT_ATTRIBUTES.clickable.name));
    },
        errorMessage:
            "Element with locator ${element.by.describeMatch(Plurality.one)} not clickable");
  }

  static Future<void> waitFor(
    WaitPredicate predicate, {
    String? errorMessage,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    WidgetTester tester = FlutterDriver.instance.tester;
    final end = tester.binding.clock.now().add(timeout);

    do {
      if (tester.binding.clock.now().isAfter(end)) {
        throw Exception(errorMessage != null
            ? '$errorMessage with ${timeout.inSeconds} seconds'
            : 'Timed out waiting for condition');
      }
      if (Platform.isAndroid) {
        await pumpAndTrySettle(timeout: const Duration(milliseconds: 200));
      }
      await Future.delayed(const Duration(milliseconds: 100));
    } while (!(await predicate()));
  }

  static Future<void> dragAndDrop(DragAndDropModel model) async {
    return TestAsyncUtils.guard(() async {
      WidgetTester tester = _getTester();
      final String sourceElementId = model.source.id;
      final String targetElementId = model.target.id;
      Session session = FlutterDriver.instance.getSessionOrThrow()!;
      FlutterElement sourceEl =
          await session.elementsCache.get(sourceElementId);
      FlutterElement targetEl =
          await session.elementsCache.get(targetElementId);
      final Offset sourceElementLocation = tester.getCenter(sourceEl.by);
      final Offset targetElementLocation = tester.getCenter(targetEl.by);
      final TestGesture gesture =
          await tester.startGesture(sourceElementLocation, pointer: 7);
      await gesture.moveTo(targetElementLocation);
      await tester.pump();
      await gesture.up();
      await tester.pump();
    });
  }

  static Future<Finder> scrollUntilVisible({
    required FindElementModel finder,
    FindElementModel? scrollView,
    double? delta,
    AxisDirection? scrollDirection,
    int? maxScrolls,
    Duration? settleBetweenScrollsTimeout,
    Duration? dragDuration,
  }) async {
    delta ??= defaultScrollDelta;
    maxScrolls ??= defaultScrollMaxIteration;
    WidgetTester tester = _getTester();
    Finder scrollViewElement = scrollView != null
        ? await locateElement(scrollView)
        : find.byType(Scrollable);
    Finder elementToFind = await locateElement(finder, evaluatePresence: false);

    await waitForElementExist(FlutterElement.fromBy(scrollViewElement),
        timeout: defaultWaitTimeout);
    AxisDirection direction;
    if (scrollDirection == null) {
      if (scrollViewElement.evaluate().first.widget is Scrollable) {
        direction =
            tester.firstWidget<Scrollable>(scrollViewElement).axisDirection;
      } else {
        direction = AxisDirection.down;
      }
    } else {
      direction = scrollDirection;
    }

    return TestAsyncUtils.guard<Finder>(() async {
      Offset moveStep;
      switch (direction) {
        case AxisDirection.up:
          moveStep = Offset(0, delta!);
        case AxisDirection.down:
          moveStep = Offset(0, -delta!);
        case AxisDirection.left:
          moveStep = Offset(delta!, 0);
        case AxisDirection.right:
          moveStep = Offset(-delta!, 0);
      }

      scrollViewElement = scrollViewElement.hitTestable().first;
      dragDuration ??= const Duration(milliseconds: 100);
      settleBetweenScrollsTimeout ??= const Duration(seconds: 5);

      var iterationsLeft = maxScrolls!;
      while (iterationsLeft > 0 &&
          elementToFind.hitTestable().evaluate().isEmpty) {
        await tester.timedDrag(
          scrollViewElement,
          moveStep,
          dragDuration!,
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100),
            EnginePhase.sendSemanticsUpdate, settleBetweenScrollsTimeout!);
        iterationsLeft -= 1;
      }

      if (iterationsLeft <= 0) {
        throw FlutterAutomationException("Wait timeout");
      }

      return elementToFind;
    });
  }

  static Future<void> pumpAndTrySettle({
    Duration duration = const Duration(milliseconds: 100),
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
    Duration timeout = const Duration(milliseconds: 200),
  }) async {
    try {
      WidgetTester tester = _getTester();
      await tester.pumpAndSettle(
        duration,
        phase,
        timeout,
      );
    } on FlutterError catch (err) {
      if (err.message == 'pumpAndSettle timed out') {
        //This method ignores pumpAndSettle timeouts on purpose
      } else {
        rethrow;
      }
    }
  }
}
