class FindElementModel {
  String strategy;
  String selector;
  String? context;

  FindElementModel(
      {required this.strategy, required this.selector, this.context});

  factory FindElementModel.fromJson(Map<String, dynamic> json) =>
      FindElementModel(
        strategy: (json['strategy'] ?? json['using']) as String,
        selector: (json['selector'] ?? json['value']) as String,
        context: json['context'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'strategy': strategy,
        'selector': selector,
        "using": strategy,
        "value": selector,
        'context': context,
      };
}
