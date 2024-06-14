import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/internal/flutter_element.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/models/api/element.dart';
import 'package:appium_flutter_server/src/models/api/scroll_till_visible.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shelf_plus/shelf_plus.dart';

class ScrollTillVisibleHandler extends RequestHandler {
  ScrollTillVisibleHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    var sessionId = getSessionId(request);
    var session = FlutterDriver.instance.getSessionOrThrow()!;
    ScrollTillVisibleModel model =
        ScrollTillVisibleModel.fromJson(await request.body.asJson);

    AxisDirection? scrollDirection = model.scrollDirection ?? null;
    Duration? settleBetweenScrollsTimeout =
        model.settleBetweenScrollsTimeout != null
            ? Duration(milliseconds: model.settleBetweenScrollsTimeout!)
            : null;
    Duration? dragDuration = model.dragDuration != null
        ? Duration(milliseconds: model.dragDuration!)
        : null;

    Finder by = await ElementHelper.scrollUntilVisible(
        finder: model.finder,
        scrollDirection: scrollDirection,
        settleBetweenScrollsTimeout: settleBetweenScrollsTimeout,
        dragDuration: dragDuration,
        maxScrolls: model.maxScrolls,
        scrollView: model.scrollView,
        delta: model.delta);
    FlutterElement element = await session.elementsCache.add(by);
    return AppiumResponse(sessionId, ElementModel.fromElement(element.id));
  }
}
