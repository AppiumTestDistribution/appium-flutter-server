// ----- TESTSIGMA CHANGES START -----
import 'dart:convert';

import 'package:appium_flutter_server/src/ts_recorder/page_source/node.dart';
import 'package:appium_flutter_server/src/ts_recorder/page_source/node_reader.dart';
import 'package:appium_flutter_server/src/ts_recorder/page_source/screen.dart';
import 'package:appium_flutter_server/src/ts_recorder/page_source/visibility.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// The result of one walk.
class PageSource {
  final Screen screen;
  final List<Node> nodes;
  final bool truncated;
  final bool hasPlatformViews;

  PageSource(
      {required this.screen,
      required this.nodes,
      required this.truncated,
      required this.hasPlatformViews});

  // FNV-1a 32-bit hash of the serialized nodes. The same screen gives the same hash.
  String get hash => _hashOf(nodes.map((node) => node.toJson()).toList());

  Map<String, dynamic> toJson({required bool settled}) {
    final List<Map<String, dynamic>> nodesJson =
        nodes.map((node) => node.toJson()).toList();
    return {
      "hash": _hashOf(nodesJson),
      "settled": settled,
      "truncated": truncated,
      "hasPlatformViews": hasPlatformViews,
      "screen": screen.toJson(),
      "nodes": nodesJson,
    };
  }

  static String _hashOf(List<Map<String, dynamic>> nodesJson) {
    int hash = 0x811c9dc5;
    for (final int byte in utf8.encode(jsonEncode(nodesJson))) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, "0");
  }
}

// Goes through every widget once and builds the flat node list.
class TreeWalker {
  static const int defaultMaxNodes = 600;

  // Two rects closer than this value are the same box.
  static const double _sameRectTolerance = 0.01;

  final Screen screen;
  final int maxNodes;

  final List<_Box> _boxes = [];
  final List<_OverlayScope> _overlays = [];
  bool _hasPlatformViews = false;

  TreeWalker({required this.screen, this.maxNodes = defaultMaxNodes});

  PageSource walk(Element rootElement) {
    final _Box root = _Box(Node(screen.rect, screen.rect), isRoot: true);
    _boxes.add(root);
    _visit(
        rootElement, _Context(box: root, pending: const [], clip: screen.rect));
    _markBlocked();

    final List<Node> nodes = [];
    final bool truncated = !_emit(root, null, nodes);
    return PageSource(
        screen: screen,
        nodes: nodes,
        truncated: truncated,
        hasPlatformViews: _hasPlatformViews);
  }

  void _visit(Element element, _Context context) {
    final Widget widget = element.widget;

    // Keep the barrier position for the "blocked" flag. Do not report the barrier.
    if (VisibilityRules.isModalBarrier(widget)) {
      context.overlay?.barrierOrder = _boxes.length;
      return;
    }
    if (VisibilityRules.isCoveredRoute(widget)) return;
    if (!VisibilityRules.isPaintedByParent(element)) return;

    _Context next = context;
    if (VisibilityRules.isOverlay(widget)) {
      final _OverlayScope overlay = _OverlayScope(_boxes.length);
      _overlays.add(overlay);
      next = next.copyWith(overlay: overlay);
    }
    if (VisibilityRules.blocksInput(widget)) {
      next = next.copyWith(inputBlocked: true);
    }

    // A component widget has no render object. It joins the next box below it.
    if (element is! RenderObjectElement) {
      _visitChildren(
          element, next.copyWith(pending: [...next.pending, element]));
      return;
    }

    final RenderObject renderObject = element.renderObject;
    if (VisibilityRules.isPlatformView(renderObject)) _hasPlatformViews = true;

    // Slivers and the RenderView do not make a box. Their component widgets are dropped.
    if (renderObject is! RenderBox) {
      _visitChildren(element, next.copyWith(pending: const []));
      return;
    }
    // A box without layout is not on the screen. Its subtree has no layout too.
    if (!renderObject.hasSize || !renderObject.attached) return;

    final Rect rect = MatrixUtils.transformRect(
        renderObject.getTransformTo(null), Offset.zero & renderObject.size);
    final _Box box =
        _sameRect(rect, next.box.node.rect) ? next.box : _startBox(rect, next);
    for (final Element pending in next.pending) {
      box.read(pending);
    }
    box.read(element);

    Rect clip = next.clip;
    if (renderObject is RenderAbstractViewport) clip = clip.intersect(rect);

    final _Context childContext =
        next.copyWith(box: box, pending: const [], clip: clip);
    final int? paintedIndex = VisibilityRules.paintedChildIndex(element);
    if (paintedIndex == null) {
      _visitChildren(element, childContext);
      return;
    }
    int index = 0;
    element.visitChildElements((child) {
      if (index++ == paintedIndex) _visit(child, childContext);
    });
  }

  void _visitChildren(Element element, _Context context) {
    element.visitChildElements((child) => _visit(child, context));
  }

  _Box _startBox(Rect rect, _Context context) {
    final _Box box =
        _Box(Node(rect, rect.intersect(context.clip)), order: _boxes.length);
    if (context.inputBlocked) box.node.enabled = false;
    context.box.children.add(box);
    _boxes.add(box);
    return box;
  }

  bool _sameRect(Rect a, Rect b) =>
      (a.left - b.left).abs() < _sameRectTolerance &&
      (a.top - b.top).abs() < _sameRectTolerance &&
      (a.right - b.right).abs() < _sameRectTolerance &&
      (a.bottom - b.bottom).abs() < _sameRectTolerance;

  // Mark the boxes that come before the topmost barrier in the same Overlay.
  void _markBlocked() {
    for (final _OverlayScope overlay in _overlays) {
      final int? barrierOrder = overlay.barrierOrder;
      if (barrierOrder == null) continue;
      for (int order = overlay.startOrder; order < barrierOrder; order++) {
        _boxes[order].node.blocked = true;
      }
    }
  }

  // Add kept boxes in pre-order. A dropped box gives its children to the nearest kept box.
  // Returns false when the walk stops at maxNodes.
  bool _emit(_Box box, String? parentId, List<Node> nodes) {
    String? childParentId = parentId;
    if (box.isKept) {
      if (nodes.length >= maxNodes) return false;
      final Node node = box.finish();
      node.id = "n${nodes.length}";
      node.parent = parentId;
      nodes.add(node);
      childParentId = node.id;
    }
    for (final _Box child in box.children) {
      if (!_emit(child, childParentId, nodes)) return false;
    }
    return true;
  }
}

class _Box {
  // These widget types make a box interactive. GestureDetector, InkWell,
  // Material buttons and TextField all build one of them.
  static const Set<String> _gestureTypes = {"RawGestureDetector", "Listener"};

  final Node node;
  final bool isRoot;
  final int order;
  final List<_Box> children = [];

  _Box(this.node, {this.isRoot = false, this.order = 0});

  void read(Element element) => NodeReader.read(element, node);

  bool get _isOnScreen =>
      node.visibleRect.width > 0 && node.visibleRect.height > 0;

  bool get _hasGesture {
    for (final String name in node.types) {
      // Navigator adds a Listener for its own use. It is not a tap target.
      if (name == "Listener" && node.types.contains("Navigator")) continue;
      if (_gestureTypes.contains(name)) return true;
    }
    return false;
  }

  bool get isKept =>
      isRoot ||
      (_isOnScreen &&
          (node.hasFinderValue ||
              _hasGesture ||
              node.types.contains("EditableText") ||
              node.types.contains("Scrollable")));

  // Set the flags that come from the full list of types.
  Node finish() {
    node.editable = node.types.contains("EditableText");
    // EditableText builds its own Scrollable. A text field is not a list.
    node.scrollable = node.types.contains("Scrollable") && !node.editable;
    // Scrollable builds its own RawGestureDetector. A list is not a tap target.
    node.clickable =
        (_hasGesture || node.editable) && !node.scrollable && !node.blocked;
    // Every app and route has Focus widgets. Report focus on tap targets only.
    node.focusable = node.focusable && (_hasGesture || node.editable);
    return node;
  }
}

// One Overlay, and the position of its topmost ModalBarrier.
class _OverlayScope {
  final int startOrder;
  int? barrierOrder;

  _OverlayScope(this.startOrder);
}

class _Context {
  final _Box box;
  final List<Element> pending;
  final Rect clip;
  final _OverlayScope? overlay;
  final bool inputBlocked;

  const _Context(
      {required this.box,
      required this.pending,
      required this.clip,
      this.overlay,
      this.inputBlocked = false});

  _Context copyWith(
          {_Box? box,
          List<Element>? pending,
          Rect? clip,
          _OverlayScope? overlay,
          bool? inputBlocked}) =>
      _Context(
          box: box ?? this.box,
          pending: pending ?? this.pending,
          clip: clip ?? this.clip,
          overlay: overlay ?? this.overlay,
          inputBlocked: inputBlocked ?? this.inputBlocked);
}
// ----- TESTSIGMA CHANGES END -----
