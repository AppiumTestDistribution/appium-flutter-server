// ----- TESTSIGMA CHANGES START -----
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_source_test_utils.dart';

void main() {
  testWidgets('gives the page source response shape', (tester) async {
    await tester.pumpWidget(page(const Text("Hello")));

    final json = readPageSource(tester).toJson(settled: true);
    expect(
        json.keys,
        containsAll([
          "hash",
          "settled",
          "truncated",
          "hasPlatformViews",
          "screen",
          "nodes"
        ]));
    expect(json["settled"], isTrue);

    final screen = json["screen"] as Map<String, dynamic>;
    expect(
        screen.keys,
        containsAll([
          "width",
          "height",
          "devicePixelRatio",
          "padding",
          "viewInsets",
          "orientation"
        ]));

    final text = (json["nodes"] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((node) => node["text"] == "Hello");
    expect(text["rect"], hasLength(4));
    expect(text["type"], "Text");
  });

  testWidgets('gives the same hash for the same screen', (tester) async {
    await tester.pumpWidget(page(const TextField()));

    expect(readPageSource(tester).hash, readPageSource(tester).hash);
  });

  testWidgets('changes the hash when the user types', (tester) async {
    await tester.pumpWidget(page(const TextField()));
    final before = readPageSource(tester).hash;

    await tester.enterText(find.byType(TextField), "a");
    await tester.pump();

    expect(readPageSource(tester).hash, isNot(before));
  });
}
// ----- TESTSIGMA CHANGES END -----
