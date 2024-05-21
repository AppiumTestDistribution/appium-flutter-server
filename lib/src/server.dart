import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_router/shelf_router.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import "dart:async";

Future<void> startServer(WidgetTester tester) async {
  var app = shelf.Router();
  final fab = find.byKey(const ValueKey('increment'));

  app.get('/tap', (Request request) async {
    await tester.tap(fab);
    return Response.ok('hello-world');
  });

  await io.serve(app, 'localhost', 8080);
  return Completer<void>().future;
}
