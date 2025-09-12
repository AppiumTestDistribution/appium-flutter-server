import 'package:appium_flutter_server/src/internal/widget_predicates.dart';
import 'package:appium_flutter_server/src/models/api/find_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum ElementLookupStrategy {
  BY_KEY,
  BY_SEMANTICS_LABEL,
  BY_TOOLTIP,
  BY_TEXT,
  BY_TEXT_CONTAINING,
  BY_TYPE,
  BY_ICON_POINT,
  BY_ICON_NAME,
  // Complex strategies
  BY_ANCESTOR,
  BY_DESCENDANT,
  BY_PAGE_OBJECT,
  BY_CUSTOM_PREDICATE,
}

var a = Icons.accessible;

extension ElementLookupStrategyExtension on ElementLookupStrategy {
  ElementLookupStrategy ofName(String strategyName) {
    return ElementLookupStrategy.values.byName(strategyName);
  }

  /// Convert FindElementModel to Finder - supports both simple and complex finders
  Future<Finder> toFinder(FindElementModel model) async {
    switch (this) {
      // Simple strategies
      case ElementLookupStrategy.BY_KEY:
        return find.byKey(Key(model.selectorString!), skipOffstage: false);
      case ElementLookupStrategy.BY_SEMANTICS_LABEL:
        return find.bySemanticsLabel(model.selectorString!,
            skipOffstage: false);
      case ElementLookupStrategy.BY_TOOLTIP:
        return find.byTooltip(model.selectorString!, skipOffstage: false);
      case ElementLookupStrategy.BY_TEXT:
        return find.text(model.selectorString!, skipOffstage: false);
      case ElementLookupStrategy.BY_TEXT_CONTAINING:
        return find.textContaining(model.selectorString!, skipOffstage: false);
      case ElementLookupStrategy.BY_TYPE:
        return find.byWidgetPredicate(
          filterByWidgetName(model.selectorString!),
          skipOffstage: false,
        );
      case ElementLookupStrategy.BY_ICON_POINT:
        return find.byWidgetPredicate(
          filterByIconCode(int.parse(model.selectorString!)),
          skipOffstage: false,
        );
      case ElementLookupStrategy.BY_ICON_NAME:
        return find.byIcon(_getIconByName(model.selectorString!));

      // Complex strategies
      case ElementLookupStrategy.BY_ANCESTOR:
        return await _createAncestorFinder(model);
      case ElementLookupStrategy.BY_DESCENDANT:
        return await _createDescendantFinder(model);
      case ElementLookupStrategy.BY_PAGE_OBJECT:
        return await _createPageObjectFinder(model);
      case ElementLookupStrategy.BY_CUSTOM_PREDICATE:
        return _createCustomPredicateFinder(model);
    }
  }

  /// Create ancestor finder from complex model
  Future<Finder> _createAncestorFinder(FindElementModel model) async {
    final selectorMap = model.selectorMap!;
    final ofModel = FindElementModel.fromJson(selectorMap['of']);
    final matchingModel = FindElementModel.fromJson(selectorMap['matching']);
    final matchRoot = selectorMap['matchRoot'] ?? false;

    final ofFinder = await _resolveFinder(ofModel);
    final matchingFinder = await _resolveFinder(matchingModel);

    return find.ancestor(
      of: ofFinder,
      matching: matchingFinder,
      matchRoot: matchRoot,
    );
  }

  /// Create descendant finder from complex model
  Future<Finder> _createDescendantFinder(FindElementModel model) async {
    final selectorMap = model.selectorMap!;
    final ofModel = FindElementModel.fromJson(selectorMap['of']);
    final matchingModel = FindElementModel.fromJson(selectorMap['matching']);
    final matchRoot = selectorMap['matchRoot'] ?? false;

    final ofFinder = await _resolveFinder(ofModel);
    final matchingFinder = await _resolveFinder(matchingModel);

    return find.descendant(
      of: ofFinder,
      matching: matchingFinder,
      matchRoot: matchRoot,
    );
  }

  /// Create page object finder (custom implementation)
  Future<Finder> _createPageObjectFinder(FindElementModel model) async {
    final selectorMap = model.selectorMap!;
    final pageObjectName = selectorMap['pageObject'] as String;
    final elementModel = FindElementModel.fromJson(selectorMap['element']);

    // This could be extended to load page objects from configuration
    // For now, just resolve the inner element
    print('Loading page object: $pageObjectName');
    return await _resolveFinder(elementModel);
  }

  /// Create custom predicate finder
  Finder _createCustomPredicateFinder(FindElementModel model) {
    final selectorMap = model.selectorMap!;
    final predicateType = selectorMap['predicateType'] as String;
    final parameters = selectorMap['parameters'] as Map<String, dynamic>;

    switch (predicateType) {
      case 'widget_property':
        return find.byWidgetPredicate(
          (widget) => _checkWidgetProperty(widget, parameters),
          skipOffstage: false,
        );
      case 'element_property':
        return find.byElementPredicate(
          (element) => _checkElementProperty(element, parameters),
        );
      default:
        throw ArgumentError('Unknown predicate type: $predicateType');
    }
  }

  /// Recursively resolve any FindElementModel to a Finder
  Future<Finder> _resolveFinder(FindElementModel model) async {
    final strategy = ElementLookupStrategy.values
        .firstWhere((s) => s.name == model.strategy);
    return await strategy.toFinder(model);
  }

  /// Helper methods for custom predicates
  bool _checkWidgetProperty(Widget widget, Map<String, dynamic> parameters) {
    final propertyName = parameters['property'] as String;
    final expectedValue = parameters['value'];

    // This could be extended with reflection or a property registry
    switch (propertyName) {
      case 'runtimeType':
        return widget.runtimeType.toString() == expectedValue;
      case 'key':
        return widget.key?.toString() == expectedValue;
      default:
        return false;
    }
  }

  bool _checkElementProperty(Element element, Map<String, dynamic> parameters) {
    final propertyName = parameters['property'] as String;
    final expectedValue = parameters['value'];

    switch (propertyName) {
      case 'semanticsLabel':
        return element.renderObject?.debugSemantics?.label == expectedValue;
      default:
        return false;
    }
  }

  /// Get icon by name (helper method)
  IconData _getIconByName(String iconName) {
    // This could be extended with a comprehensive icon registry
    switch (iconName.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'search':
        return Icons.search;
      case 'settings':
        return Icons.settings;
      case 'menu':
        return Icons.menu;
      default:
        return Icons.help_outline; // Default fallback
    }
  }

  String get name {
    switch (this) {
      case ElementLookupStrategy.BY_KEY:
        return '-flutter key';
      case ElementLookupStrategy.BY_SEMANTICS_LABEL:
        return '-flutter semantics label';
      case ElementLookupStrategy.BY_TOOLTIP:
        return '-flutter tooltip';
      case ElementLookupStrategy.BY_TEXT:
        return '-flutter text';
      case ElementLookupStrategy.BY_TEXT_CONTAINING:
        return '-flutter text containing';
      case ElementLookupStrategy.BY_TYPE:
        return '-flutter type';
      case ElementLookupStrategy.BY_ICON_POINT:
        return '-flutter icon point';
      case ElementLookupStrategy.BY_ICON_NAME:
        return '-flutter icon name';
      case ElementLookupStrategy.BY_ANCESTOR:
        return '-flutter ancestor';
      case ElementLookupStrategy.BY_DESCENDANT:
        return '-flutter descendant';
      case ElementLookupStrategy.BY_PAGE_OBJECT:
        return '-flutter page_object';
      case ElementLookupStrategy.BY_CUSTOM_PREDICATE:
        return '-flutter custom_predicate';
    }
  }
}
