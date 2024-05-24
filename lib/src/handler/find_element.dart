import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/element_lookup_strategy.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:appium_flutter_server/src/models/session.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_plus/shelf_plus.dart';

class FindElementHandler extends RequestHandler {
  FindElementHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    FindElementModel model =
        FindElementModel.fromJson(await request.body.asJson);

    final String method = model.strategy;
    final String selector = model.selector;
    final String? contextId = model.context == "" ? null : model.context;

    if (contextId == null) {
      log('"method: $method, selector: $selector');
    } else {
      log('"method: $method, selector: $selector, contextId: $contextId');
    }

    Session? session = FlutterDriver.instance.getSessionOrThrow();
    final Finder by = ElementLookupStrategy.values
        .firstWhere((val) => val.name == method)
        .toFinder(selector);
    Finder matchedBy =
        await ElementHelper.findElement(by, contextId: contextId);

    //Comment this code
    await FlutterDriver.instance.tester.tap(matchedBy);

    FlutterElement flutterElement = await session!.elementsCache.add(matchedBy);

    return AppiumResponse(
        session.sessionId, ElementModel.fromElement(flutterElement.id));
  }
}
