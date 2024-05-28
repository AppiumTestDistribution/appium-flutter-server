import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class AppiumTestWidgetsFlutterBinding
    extends IntegrationTestWidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    AppiumTestWidgetsFlutterBinding();
    assert(WidgetsBinding.instance is AppiumTestWidgetsFlutterBinding);
    return WidgetsBinding.instance;
  }

  @override
  TestBindingEventSource get pointerEventSource => TestBindingEventSource.test;

}
