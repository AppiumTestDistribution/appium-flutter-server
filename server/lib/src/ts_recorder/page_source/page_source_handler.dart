// ----- TESTSIGMA CHANGES START -----
import 'package:appium_flutter_server/src/driver.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/models/api/appium_response.dart';
import 'package:appium_flutter_server/src/ts_recorder/page_source/screen.dart';
import 'package:appium_flutter_server/src/ts_recorder/page_source/tree_walker.dart';
import 'package:appium_flutter_server/src/utils/element_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf/shelf.dart';

// RequestHandler checks the session id in the path before this handler runs.
class PageSourceHandler extends RequestHandler {
  PageSourceHandler(super.route);

  @override
  Future<AppiumResponse> handle(Request request) async {
    final String sessionId = getSessionId(request);
    final int maxNodes = _readMaxNodes(request);

    await ElementHelper.pumpAndTrySettle();
    final WidgetTester tester = FlutterDriver.instance.tester;
    
    // A frame is still scheduled when an animation did not stop.
    final bool settled = !tester.binding.hasScheduledFrame;

    final PageSource pageSource =
        TreeWalker(screen: Screen.fromView(tester.view), maxNodes: maxNodes)
            .walk(tester.binding.rootElement!);
    return AppiumResponse(sessionId, pageSource.toJson(settled: settled));
  }

  int _readMaxNodes(Request request) {
    final int? value =
        int.tryParse(request.url.queryParameters["maxNodes"] ?? "");
    if (value == null || value < 1) return TreeWalker.defaultMaxNodes;
    return value;
  }
}
// ----- TESTSIGMA CHANGES END -----
