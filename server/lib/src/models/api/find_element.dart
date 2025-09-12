class FindElementModel {
  String strategy;
  dynamic selector; // Changed from String to dynamic to support complex finders
  String? context;
  Map<String, dynamic>? parameters; // Additional parameters for complex finders

  FindElementModel({
    required this.strategy,
    required this.selector,
    this.context,
    this.parameters,
  });

  factory FindElementModel.fromJson(Map<String, dynamic> json) {
    return FindElementModel(
      strategy: (json['strategy'] ?? json['using']) as String,
      selector: json['selector'] ?? json['value'], // Can be String or Map
      context: json['context'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'strategy': strategy,
        'selector': selector,
        "using": strategy,
        "value": selector,
        'context': context,
        'parameters': parameters,
      };

  // /// Factory method for simple finders (backward compatibility)
  // factory FindElementModel.simple(String strategy, String selector,
  //     {String? context}) {
  //   return FindElementModel(
  //     strategy: strategy,
  //     selector: selector,
  //     context: context,
  //   );
  // }

  // /// Factory method for ancestor finder
  // factory FindElementModel.ancestor({
  //   required FindElementModel of,
  //   required FindElementModel matching,
  //   bool matchRoot = false,
  //   String? context,
  // }) {
  //   return FindElementModel(
  //     strategy: 'ancestor',
  //     selector: {
  //       'of': of.toJson(),
  //       'matching': matching.toJson(),
  //       'matchRoot': matchRoot,
  //     },
  //     context: context,
  //   );
  // }

  // /// Factory method for descendant finder
  // factory FindElementModel.descendant({
  //   required FindElementModel of,
  //   required FindElementModel matching,
  //   bool matchRoot = false,
  //   String? context,
  // }) {
  //   return FindElementModel(
  //     strategy: 'descendant',
  //     selector: {
  //       'of': of.toJson(),
  //       'matching': matching.toJson(),
  //       'matchRoot': matchRoot,
  //     },
  //     context: context,
  //   );
  // }

  /// Get the selector as a Map (for complex finders)
  Map<String, dynamic>? get selectorMap => selector is Map<String, dynamic>
      ? selector as Map<String, dynamic>
      : null;

  /// Get the selector as a String (for simple finders)
  String? get selectorString => selector is String ? selector as String : null;
}
