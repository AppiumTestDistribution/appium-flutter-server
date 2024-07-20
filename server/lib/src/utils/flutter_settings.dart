import 'package:appium_flutter_server/src/driver.dart';

Duration getElementWaitTimeout() {
  if(FlutterDriver.instance.getSession()?.capabilities['flutterElementWaitTimeout'] != null) {
    return Duration(
        milliseconds: FlutterDriver.instance.getSession()?.capabilities['flutterElementWaitTimeout']);
  } else {
    return const Duration(milliseconds: 5000);
  }
}
