class FindElementModel {
  String strategy;
  String selector;
  String? context;

  FindElementModel(
      {required this.strategy, required this.selector, this.context});

  factory FindElementModel.fromJson(Map<String, dynamic> json) =>
      FindElementModel(
        strategy: json['strategy'] as String,
        selector: json['selector'] as String,
        context: json['context'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'strategy': strategy,
        'selector': selector,
        'context': context,
      };
}
