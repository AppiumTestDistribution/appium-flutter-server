import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appium_flutter_server/src/server.dart';
import 'package:integration_test/integration_test.dart';

void initializeTest(Widget app) async {
  IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('appium flutter server', (tester) async {
    await tester.binding.setSurfaceSize(Size(
      tester.view.physicalConstraints.maxWidth *
          tester.view.physicalSize.aspectRatio,
      tester.view.physicalConstraints.maxHeight *
          tester.view.physicalSize.aspectRatio,
    ));

    await tester.pumpWidget(app);

    await startServer(tester, binding);
  }, timeout: const Timeout(Duration(seconds: 600)));
}

   // tester.view.physicalSize = Size(tester.view.physicalConstraints.maxWidth,
    //     tester.view.physicalConstraints.maxHeight);