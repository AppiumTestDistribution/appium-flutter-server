// ----- TESTSIGMA CHANGES START -----
import 'package:flutter/widgets.dart';

// One on-screen box that the page source reports.
class Node {
  // Framework widgets that only wrap, lay out or decorate a child.
  // They are not a good type for a node, and they make the payload large.
  static const Set<String> _wrapperTypes = {
    "AbsorbPointer",
    "Actions",
    "Align",
    "AnimatedBuilder",
    "AnimatedDefaultTextStyle",
    "AnimatedOpacity",
    "AnimatedPhysicalModel",
    "AnimatedTheme",
    "AutomaticKeepAlive",
    "Banner",
    "Builder",
    "Center",
    "CheckedModeBanner",
    "ClipOval",
    "ClipPath",
    "ClipRRect",
    "ClipRect",
    "ColoredBox",
    "CompositedTransformFollower",
    "CompositedTransformTarget",
    "ConstrainedBox",
    "Container",
    "CupertinoTheme",
    "CustomMultiChildLayout",
    "CustomPaint",
    "CustomSingleChildLayout",
    "DecoratedBox",
    "DefaultSelectionStyle",
    "DefaultTextEditingShortcuts",
    "DefaultTextStyle",
    "Directionality",
    "DualTransitionBuilder",
    "ExcludeFocus",
    "ExcludeSemantics",
    "Expanded",
    "FadeTransition",
    "Flexible",
    "Focus",
    "FocusScope",
    "FocusTraversalGroup",
    "FocusableActionDetector",
    "FractionalTranslation",
    "GlowingOverscrollIndicator",
    "Hero",
    "HeroControllerScope",
    "IconTheme",
    "IgnorePointer",
    "IndexedSemantics",
    "Ink",
    "InheritedCupertinoTheme",
    "KeepAlive",
    "KeyedSubtree",
    "LayoutBuilder",
    "LayoutId",
    "LimitedBox",
    "ListenableBuilder",
    "Listener",
    "Localizations",
    "Material",
    "MatrixTransition",
    "MediaQuery",
    "MergeSemantics",
    "MouseRegion",
    "Navigator",
    "NotificationListener",
    "Offstage",
    "Opacity",
    "Overlay",
    "OverlayPortal",
    "Padding",
    "PageStorage",
    "PhysicalModel",
    "PhysicalShape",
    "Positioned",
    "PrimaryScrollController",
    "RepaintBoundary",
    "RestorationScope",
    "RootRestorationScope",
    "RotationTransition",
    "SafeArea",
    "ScaffoldMessenger",
    "ScaleTransition",
    "ScrollConfiguration",
    "ScrollNotificationObserver",
    "Semantics",
    "SharedAppData",
    "ShortcutRegistrar",
    "Shortcuts",
    "SizeChangedLayoutNotifier",
    "SizeTransition",
    "SizedBox",
    "SlideTransition",
    "StatefulBuilder",
    "StretchEffect",
    "StretchingOverscrollIndicator",
    "TapRegion",
    "TapRegionSurface",
    "TextFieldTapRegion",
    "Theme",
    "TickerMode",
    "Title",
    "Transform",
    "UndoHistory",
    "UnconstrainedBox",
    "UnmanagedRestorationScope",
    "ValueListenableBuilder",
    "Visibility",
  };

  String id = "";
  String? parent;
  final Rect rect;
  final Rect visibleRect;
  final List<String> types = [];

  String? key;
  String? text;
  String? inputValue;
  String? tooltip;
  int? icon;
  String? semanticsLabel;
  String? hint;
  String? label;

  bool clickable = false;
  bool editable = false;
  bool? enabled;
  bool focusable = false;
  bool focused = false;
  bool? checked;
  bool scrollable = false;
  bool blocked = false;

  Node(this.rect, this.visibleRect);

  // Public types that are not framework wrappers. A name with "_" is private.
  List<String> get publicTypes => types
      .where((name) => !name.startsWith("_") && !_isWrapper(name))
      .toList();

  // Use the first public type that is not a wrapper.
  String get type {
    final List<String> names = publicTypes;
    if (names.isNotEmpty) return names.first;
    return types.firstWhere((name) => !name.startsWith("_"),
        orElse: () => types.isEmpty ? "" : types.first);
  }

  // Compare without the generic part, for example "NotificationListener<T>".
  static bool _isWrapper(String name) =>
      _wrapperTypes.contains(name.split("<").first);

  bool get hasFinderValue =>
      key != null ||
      text != null ||
      tooltip != null ||
      icon != null ||
      semanticsLabel != null;

  // Add the type name. Do not add the same name two times in sequence.
  void addType(String name) {
    if (types.isEmpty || types.last != name) types.add(name);
  }

  Map<String, dynamic> toJson() {
    final List<String> publicTypes = this.publicTypes;
    final bool interactive = clickable || editable || scrollable;
    return {
      "id": id,
      "parent": parent,
      "type": type,
      if (publicTypes.length > 1) "types": publicTypes,
      "rect": _rectToJson(rect),
      "visibleRect": _rectToJson(visibleRect),
      if (key != null) "key": key,
      if (text != null) "text": text,
      if (inputValue != null) "inputValue": inputValue,
      if (tooltip != null) "tooltip": tooltip,
      if (icon != null) "icon": icon,
      if (semanticsLabel != null) "semanticsLabel": semanticsLabel,
      if (hint != null) "hint": hint,
      if (label != null) "label": label,
      if (clickable) "clickable": true,
      if (editable) "editable": true,
      if (interactive || enabled == false) "enabled": enabled ?? true,
      if (focusable) "focusable": true,
      if (focused) "focused": true,
      if (checked != null) "checked": checked,
      if (scrollable) "scrollable": true,
      if (blocked) "blocked": true,
    };
  }

  // Keep one decimal place. This makes the payload small and the hash stable.
  static List<double> _rectToJson(Rect rect) =>
      [rect.left, rect.top, rect.width, rect.height].map(_round).toList();

  static double _round(double value) => (value * 10).roundToDouble() / 10;
}
// ----- TESTSIGMA CHANGES END -----
