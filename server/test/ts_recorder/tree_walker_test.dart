// ----- TESTSIGMA CHANGES START -----
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_source_test_utils.dart';

void main() {
  testWidgets('gives the real global rect of a widget', (tester) async {
    await tester.pumpWidget(page(Center(
        child: ElevatedButton(
            key: const ValueKey("login"),
            onPressed: () {},
            child: const Text("Log in")))));

    final pageSource = readPageSource(tester);
    final button = nodeWithKey(pageSource, "login")!;
    expect(button.type, "ElevatedButton");
    expect(button.rect, tester.getRect(find.byKey(const ValueKey("login"))));
    expect(nodeWithText(pageSource, "Log in")!.rect,
        tester.getRect(find.text("Log in")));
  });

  testWidgets('starts with the root and links each node to a parent',
      (tester) async {
    await tester.pumpWidget(page(ElevatedButton(
        key: const ValueKey("login"),
        onPressed: () {},
        child: const Text("Log in"))));

    final pageSource = readPageSource(tester);
    final root = pageSource.nodes.first;
    expect(root.id, "n0");
    expect(root.parent, isNull);
    expect(root.rect,
        Offset.zero & tester.view.physicalSize / tester.view.devicePixelRatio);

    final ids = pageSource.nodes.map((node) => node.id).toSet();
    for (final node in pageSource.nodes.skip(1)) {
      expect(ids, contains(node.parent));
    }

    // The text is inside the button, so a node of the button is an ancestor.
    final text = nodeWithText(pageSource, "Log in")!;
    final button = nodeWithKey(pageSource, "login")!;
    final byId = {for (final node in pageSource.nodes) node.id: node};
    String? parent = text.parent;
    final ancestors = <String>[];
    while (parent != null) {
      ancestors.add(parent);
      parent = byId[parent]!.parent;
    }
    expect(ancestors, contains(button.id));
  });

  testWidgets('drops layout-only boxes and keeps their children',
      (tester) async {
    await tester.pumpWidget(page(const Padding(
        padding: EdgeInsets.all(20),
        child: Align(child: SizedBox(width: 200, child: Text("Inside"))))));

    final pageSource = readPageSource(tester);
    expect(pageSource.nodes.where((node) => node.type == "Padding"), isEmpty);
    expect(pageSource.nodes.where((node) => node.type == "Align"), isEmpty);
    expect(nodeWithText(pageSource, "Inside")!.parent, "n0");
  });

  testWidgets('keeps rects correct after a scroll', (tester) async {
    await tester.pumpWidget(page(ListView(children: [
      for (int i = 0; i < 40; i++)
        ListTile(key: ValueKey("row$i"), title: Text("Row $i"), onTap: () {}),
    ])));

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    final pageSource = readPageSource(tester);
    final row = nodeWithKey(pageSource, "row8")!;
    expect(row.rect, tester.getRect(find.byKey(const ValueKey("row8"))));
    expect(row.clickable, isTrue);
    expect(nodeWithType(pageSource, "ListView")!.scrollable, isTrue);
    expect(nodeWithType(pageSource, "ListView")!.clickable, isFalse);
  });

  testWidgets('stops at maxNodes and reports truncated', (tester) async {
    await tester.pumpWidget(page(Column(children: [
      for (int i = 0; i < 10; i++) Text("Item $i"),
    ])));

    final full = readPageSource(tester);
    expect(full.truncated, isFalse);

    final capped = readPageSource(tester, maxNodes: 4);
    expect(capped.nodes, hasLength(4));
    expect(capped.truncated, isTrue);
  });
}
// ----- TESTSIGMA CHANGES END -----
