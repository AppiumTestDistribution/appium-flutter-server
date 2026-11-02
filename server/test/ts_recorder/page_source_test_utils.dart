// ----- TESTSIGMA CHANGES START -----
import 'package:appium_flutter_server/src/ts_recorder/page_source/node.dart';
import 'package:appium_flutter_server/src/ts_recorder/page_source/screen.dart';
import 'package:appium_flutter_server/src/ts_recorder/page_source/tree_walker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Walk the current widget tree of the test.
PageSource readPageSource(WidgetTester tester,
    {int maxNodes = TreeWalker.defaultMaxNodes}) {
  return TreeWalker(screen: Screen.fromView(tester.view), maxNodes: maxNodes)
      .walk(tester.binding.rootElement!);
}

Node? nodeWithKey(PageSource pageSource, String key) =>
    _firstOrNull(pageSource.nodes.where((node) => node.key == key));

Node? nodeWithText(PageSource pageSource, String text) =>
    _firstOrNull(pageSource.nodes.where((node) => node.text == text));

Node? nodeWithType(PageSource pageSource, String type) =>
    _firstOrNull(pageSource.nodes.where((node) => node.types.contains(type)));

Node? _firstOrNull(Iterable<Node> nodes) => nodes.isEmpty ? null : nodes.first;

Widget page(Widget body) => MaterialApp(home: Scaffold(body: body));
// ----- TESTSIGMA CHANGES END -----
