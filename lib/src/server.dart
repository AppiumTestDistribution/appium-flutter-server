import 'package:appium_flutter_server/src/handler/delete_session.dart';
import 'package:appium_flutter_server/src/handler/find_element.dart';
import 'package:appium_flutter_server/src/handler/new_session.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/handler/sample/screenshot.dart';
import 'package:appium_flutter_server/src/handler/sample/tap_handler.dart';
import 'package:appium_flutter_server/src/handler/status.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/utils.dart';
import 'package:shelf_plus/shelf_plus.dart' as shelf_plus;

class FlutterServer {
  final bool _isStarted = false;
  late shelf_plus.RouterPlus _app;
  static final FlutterServer _instance = FlutterServer._();

  FlutterServer._() {
    _app = shelf_plus.Router().plus;

    _registerRoutes();
  }

  static FlutterServer get instance => _instance;

  void _addRoute(HttpMethod method, RequestHandler handler) {
    _app.add(method.name, handler.route, handler.getHandler());
  }

  void _registerRoutes() {
    //GET ROUTES
    _addRoute(HttpMethod.GET, StatusHandler("/status"));
    _addRoute(HttpMethod.GET, ScreenshotHandler("/screenshot"));
    _addRoute(HttpMethod.GET, TapHandler("/tap"));

    //POST ROUTES
    _addRoute(HttpMethod.POST, NewSessionHandler("/session"));
    _addRoute(
        HttpMethod.POST, FindElementHandler("/session/<sessionId>/element"));

    //DELETE
    _addRoute(HttpMethod.DELETE, DeleteSessionHandler("/session/<sessionId>"));
  }

  void startServer({int? port}) async {
    port ??= await getFreePort();
    await shelf_plus.shelfRun(() => _app.call,
        defaultBindAddress: "localhost",
        defaultBindPort: port,
        defaultEnableHotReload: false);
    log("[Appium flutter server is listening on port $port]");
  }
}
