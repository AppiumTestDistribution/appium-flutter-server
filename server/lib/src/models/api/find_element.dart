import 'package:json_annotation/json_annotation.dart';

part 'generated/find_element.g.dart';

@JsonSerializable()
class FindElementModel {
  String strategy;
  String selector;
  String? context;

  FindElementModel(
      {required this.strategy, required this.selector, this.context});

  factory FindElementModel.fromJson(Map<String, dynamic> json) =>
      _$FindElementModelFromJson(json);

  Map<String, dynamic> toJson() => _$FindElementModelToJson(this);
}
