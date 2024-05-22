import 'package:flutter_test/flutter_test.dart';

class FlutterDriver {
  late WidgetTester _tester;

  FlutterDriver._();

  static final FlutterDriver _instance = FlutterDriver._();

  static getInstance() {
    return FlutterDriver._instance;
  }

  void initialize({required WidgetTester tester}) async {
    _tester = tester;
  }
}
