import 'dart:ffi';

import 'package:appium_flutter_server/src/handler/new_session.dart';
import 'package:appium_flutter_server/src/handler/request/request_handler.dart';
import 'package:appium_flutter_server/src/handler/sample/tap_handler.dart';
import 'package:appium_flutter_server/src/handler/status.dart';
import 'package:appium_flutter_server/src/logger.dart';
import 'package:appium_flutter_server/src/utils.dart';
import 'package:shelf_plus/shelf_plus.dart' as shelf_plus;

// Future<void> startServer(WidgetTester tester, {required int port}) async {
//   var app = shelf_plus.Router().plus;
//   final fab = find.byKey(const ValueKey('increment'));
//   final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   app.get('/tap', (Request request) async {
//     await tester.tap(fab);
//     tester.element(fab);
//     return Response.ok('Success');
//   });

//   app.get('/screenshot', (Request request) async {
//     try {
//       await binding.convertFlutterSurfaceToImage();
//       var data = await binding.takeScreenshot("screenshot");
//       await tester.pumpAndSettle();
//       return Response.ok(base64Encode(data));
//     } catch (e) {
//       return Response.ok(e.toString());
//     }
//   });

//   await shelf_plus.serve(app, 'localhost', port);
//   log('Flutter driver started on port $port');
// }

class FlutterServer {
  bool _isStarted = false;
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
    _addRoute(HttpMethod.GET, TapHandler("/tap"));

    //POST ROUTES
    _addRoute(HttpMethod.POST, NewSessionHandler("/session"));
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
