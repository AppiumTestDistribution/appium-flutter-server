import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/stale_element_reference_exception.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

class GetAttributeHandler extends RequestHandler {
  GetAttributeHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    String attribute = getRouteParam(request, "name");
    try {
      FlutterElement element = await FlutterDriver.instance
          .getSessionOrThrow()!
          .elementsCache
          .get(getElementId(request));

      List<DiagnosticsNode> nodes = FlutterDriver.instance.tester
          .widget(element.by)
          .toDiagnosticsNode()
          .getProperties();
      // List<DiagnosticsNode> data = FlutterDriver.instance.tester
      //       .getSemantics(element.by).toDiagnosticsNode().getChildren().first.getProperties();

      log("Available attributes for the element : ${element.by}");
      for (DiagnosticsNode node in nodes) {
        log("${node.name} -> ${node.value}");
      }
      log('************');
      log(nodes);
      log('###########');
      // log(data);
      // for (DiagnosticsNode node in data) {
      //   log("${node.name} -> ${node.value}");
      // }

      dynamic result = await ElementHelper.getAttribute(element, attribute);

      return AppiumResponse(getSessionId(request), result);
    } catch (e) {
      if (e is StaleElementReferenceException &&
          attribute == NATIVE_ELEMENT_ATTRIBUTES.displayed.name) {
        return AppiumResponse(getSessionId(request), false);
      }
      rethrow;
    }
  }
}
