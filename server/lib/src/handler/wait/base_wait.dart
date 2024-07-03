import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/exceptions/flutter_automation_error.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/api/wait.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class BaseWaithHandler extends RequestHandler {
  static const Duration defaultWaitTimeout = Duration(seconds: 5);

  BaseWaithHandler(super.route);

  Future<FlutterElement> resolveElement(WaitModel model) async {
    log(model);
    if (model.element != null) {
      return FlutterDriver.instance
          .getSessionOrThrow()!
          .elementsCache
          .get(model.element!.id, evaluatePresence: false);
    }
    if (model.locator != null) {
      Finder finder = await ElementHelper.locateElement(model.locator!,
          evaluatePresence: false);
      return FlutterElement.fromBy(finder);
    }
    throw FlutterAutomationException(
        "Wait method requires a valid element id or locator strategy");
  }
}
