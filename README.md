## Setup:

1. Clone the repository
2. Create new flutter application or clone any exiting flutter application
3. Add below dependency in pubspec.yaml file of the flutter application

```
dev_dependencies:
appium_flutter_server:
    path: /Users/sselvarj/Documents/git/personal/appium_flutter_server
```

NOTE: Update the path with cloned driver repository

4. create a new folder `integration_test` and create a new file `appium_server.dart` with below content

```
import 'package:appium_flutter_server/appium_flutter_server.dart';
import 'package:counter_app/main.dart';

void main() async {
  initializeTest(app: const MyApp());
}
```

5. run `flutter build apk`
6. run `./gradlew app:assembleDebug -Ptarget=/Users/sselvarj/Documents/git/personal/flutter-learnings/counter_app/integration_test/appium_server.dart` (Replace the path)
7. It will now generate a debug apk under `build/app/outputs/apk/debug/app-debug.apk`
8. Start appium server with uiautomator2 driver with below capabilities

```
{
  "capabilities": {
    "alwaysMatch": {
      "platformName": "Android",
      "appium:orientation": "PORTRAIT",
      "appium:automationName": "uiautomator2",
      "appium:app": "/Users/sselvarj/Documents/git/personal/flutter-learnings/counter_app/build/app/outputs/apk/debug/app-debug.apk",
      "appium:newCommandTimeout": 240,
      "appium:intercept": true,
      "appium:noReset": false,
      "appium:fullReset": true
    },
    "firstMatch": [
      {}
    ]
  },
  "desiredCapabilities": {
   "platformName": "Android",
      "appium:orientation": "PORTRAIT",
      "appium:automationName": "uiautomator2",
      "appium:app": "/Users/sselvarj/Documents/git/personal/flutter-learnings/counter_app/build/app/outputs/apk/debug/app-debug.apk",
      "appium:newCommandTimeout": 240,
      "appium:intercept": true,
       "appium:noReset": false,
      "appium:fullReset": true
  }
}
```

9. adb forward tcp:8080 tcp:8888
10. From the browser hit `http://localhost:8080/tap` and it should click the counter (+) icon from the app
11. From the browser hit `http://localhost:8080/screenshot` and it will return base64 screenshot image
