import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shelf_router/shelf_router.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import "dart:async";
import 'dart:convert';

Future<void> startServer(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  var app = shelf.Router();
  final fab = find.byKey(const ValueKey('increment'));

  app.get('/tap', (Request request) async {
    await tester.tap(fab);
    return Response.ok('hello-world');
  });

  app.get('/screenshot', (Request request) async {
    try {
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      var data = await binding.takeScreenshot("screenshot");
      return Response.ok(base64Encode(data));
    } catch (e) {
      return Response.ok(e.toString());
    }
  });

  await io.serve(app, 'localhost', 8080);
  return Completer<void>().future;
}
