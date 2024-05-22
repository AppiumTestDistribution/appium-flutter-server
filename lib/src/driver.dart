import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class FlutterDriver {
  late WidgetTester _tester;
  late Widget _app;

  FlutterDriver._();

  static final FlutterDriver _instance = FlutterDriver._();

  static FlutterDriver get instance => _instance;

  Widget get app => _app;

  WidgetTester get tester => _tester;

  void initialize({required WidgetTester tester, required Widget app}) async {
    _tester = tester;
    _app = app;
  }
}
