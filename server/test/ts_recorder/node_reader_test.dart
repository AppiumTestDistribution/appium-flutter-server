// ----- TESTSIGMA CHANGES START -----
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_source_test_utils.dart';

void main() {
  testWidgets('reads only ValueKey<String> keys', (tester) async {
    await tester.pumpWidget(page(Column(children: [
      ElevatedButton(
          key: const ValueKey("login"),
          onPressed: () {},
          child: const Text("Log in")),
      ElevatedButton(
          key: const ValueKey(42), onPressed: () {}, child: const Text("Int")),
    ])));

    final pageSource = readPageSource(tester);
    expect(nodeWithKey(pageSource, "login"), isNotNull);
    expect(pageSource.nodes.where((node) => node.key == "42"), isEmpty);
  });

  testWidgets('reads text, rich text, tooltip and icon', (tester) async {
    await tester.pumpWidget(page(Column(children: [
      const Text("Plain"),
      const Text.rich(
          TextSpan(text: "Rich ", children: [TextSpan(text: "text")])),
      IconButton(
          tooltip: "Search", onPressed: () {}, icon: const Icon(Icons.search)),
    ])));

    final pageSource = readPageSource(tester);
    expect(nodeWithText(pageSource, "Plain"), isNotNull);
    expect(nodeWithText(pageSource, "Rich text"), isNotNull);
    expect(pageSource.nodes.where((node) => node.tooltip == "Search"),
        hasLength(1));
    expect(
        pageSource.nodes.where((node) => node.icon == Icons.search.codePoint),
        hasLength(1));
  });

  testWidgets('reads text field values', (tester) async {
    final controller = TextEditingController(text: "abc");
    await tester.pumpWidget(page(Column(children: [
      TextField(
          controller: controller,
          decoration:
              const InputDecoration(labelText: "Email", hintText: "you@x.com")),
      const TextField(
          enabled: false, decoration: InputDecoration(labelText: "Locked")),
    ])));

    final pageSource = readPageSource(tester);
    final field = pageSource.nodes.firstWhere((node) => node.label == "Email");
    expect(field.hint, "you@x.com");
    expect(field.clickable, isTrue);

    final input =
        pageSource.nodes.firstWhere((node) => node.inputValue == "abc");
    expect(input.type, "EditableText");
    expect(input.editable, isTrue);
    expect(input.clickable, isTrue);
    expect(input.scrollable, isFalse);
    expect(input.text, isNull);

    final locked =
        pageSource.nodes.firstWhere((node) => node.label == "Locked");
    expect(locked.enabled, isFalse);
  });

  testWidgets('reads enabled and checked state', (tester) async {
    await tester.pumpWidget(page(Column(children: [
      const ElevatedButton(
          key: ValueKey("disabled"), onPressed: null, child: Text("Off")),
      Checkbox(key: const ValueKey("check"), value: true, onChanged: (_) {}),
      const Switch(key: ValueKey("switch"), value: false, onChanged: null),
    ])));

    final pageSource = readPageSource(tester);
    expect(nodeWithKey(pageSource, "disabled")!.enabled, isFalse);

    final checkbox = nodeWithKey(pageSource, "check")!;
    expect(checkbox.checked, isTrue);
    expect(checkbox.enabled, isTrue);

    final toggle = nodeWithType(pageSource, "Switch")!;
    expect(toggle.checked, isFalse);
    expect(toggle.enabled, isFalse);
  });
}
// ----- TESTSIGMA CHANGES END -----
