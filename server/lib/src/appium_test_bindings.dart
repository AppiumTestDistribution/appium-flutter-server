import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class AppiumTestWidgetsFlutterBinding
    extends IntegrationTestWidgetsFlutterBinding {
  static IntegrationTestWidgetsFlutterBinding ensureInitialized() {
    try {
      WidgetsBinding.instance;
    } catch (e) {
      AppiumTestWidgetsFlutterBinding();
      assert(WidgetsBinding.instance is AppiumTestWidgetsFlutterBinding);
      _updatePreference();
    }
    return IntegrationTestWidgetsFlutterBinding.instance;
  }

  static void _updatePreference() {
    /* To allow smooth animation during the course of test execution */
    IntegrationTestWidgetsFlutterBinding.instance.framePolicy =
        LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  @override
  TestBindingEventSource get pointerEventSource => TestBindingEventSource.test;

  @override
  bool get registerTestTextInput => true;
}
