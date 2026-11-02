// ----- TESTSIGMA CHANGES START -----
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_source_test_utils.dart';

void main() {
  testWidgets('rule 1: skips widgets that are not painted', (tester) async {
    await tester.pumpWidget(page(const Column(children: [
      Text("Shown"),
      Offstage(child: Text("Offstage")),
      Opacity(opacity: 0, child: Text("Transparent")),
      Visibility(visible: false, maintainState: true, child: Text("Hidden")),
    ])));

    final pageSource = readPageSource(tester);
    expect(nodeWithText(pageSource, "Shown"), isNotNull);
    expect(nodeWithText(pageSource, "Offstage"), isNull);
    expect(nodeWithText(pageSource, "Transparent"), isNull);
    expect(nodeWithText(pageSource, "Hidden"), isNull);
  });

  testWidgets('rule 2: skips a route under an opaque route', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(body: Text("First page"))));

    navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (_) => const Scaffold(body: Text("Second page"))));
    await tester.pumpAndSettle();

    final pageSource = readPageSource(tester);
    expect(nodeWithText(pageSource, "Second page"), isNotNull);
    expect(nodeWithText(pageSource, "First page"), isNull);
  });

  testWidgets('rule 3: keeps only the selected IndexedStack child',
      (tester) async {
    await tester.pumpWidget(page(const IndexedStack(
        index: 1, children: [Text("Tab A"), Text("Tab B"), Text("Tab C")])));

    final pageSource = readPageSource(tester);
    expect(nodeWithText(pageSource, "Tab A"), isNull);
    expect(nodeWithText(pageSource, "Tab B"), isNotNull);
    expect(nodeWithText(pageSource, "Tab C"), isNull);
  });

  testWidgets('marks the page under a dialog as blocked', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
            body: ElevatedButton(
                key: const ValueKey("behind"),
                onPressed: () {},
                child: const Text("Behind")))));

    showDialog<void>(
        context: navigatorKey.currentContext!,
        builder: (_) => AlertDialog(
            content: const Text("Dialog body"),
            actions: [TextButton(onPressed: () {}, child: const Text("OK"))]));
    await tester.pumpAndSettle();

    final pageSource = readPageSource(tester);
    expect(nodeWithText(pageSource, "Behind")!.blocked, isTrue);
    final behind = nodeWithType(pageSource, "InkWell")!;
    expect(behind.blocked, isTrue);
    expect(behind.clickable, isFalse);

    expect(nodeWithText(pageSource, "Dialog body")!.blocked, isFalse);
    final ok = nodeWithType(pageSource, "TextButton")!;
    expect(ok.blocked, isFalse);
    expect(pageSource.nodes.where((node) => node.clickable && !node.blocked),
        isNotEmpty);
  });

  testWidgets('clips a half-scrolled row to the viewport', (tester) async {
    await tester.pumpWidget(page(Column(children: [
      SizedBox(
          height: 100,
          child: ListView(children: [
            for (int i = 0; i < 5; i++)
              SizedBox(height: 60, child: Text("Row $i")),
          ])),
    ])));

    final pageSource = readPageSource(tester);
    final row1 = nodeWithText(pageSource, "Row 1")!;
    final viewport = tester.getRect(find.byType(ListView));
    expect(row1.visibleRect.bottom, viewport.bottom);
    expect(row1.rect.bottom, greaterThan(viewport.bottom));
    expect(nodeWithText(pageSource, "Row 3"), isNull);
  });
}
// ----- TESTSIGMA CHANGES END -----
