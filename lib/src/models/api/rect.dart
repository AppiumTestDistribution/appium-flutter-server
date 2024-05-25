import 'package:json_annotation/json_annotation.dart';

part 'generated/rect.g.dart';

@JsonSerializable()
class RectModel {
  double left;
  double top;
  double right;
  double bottom;

  RectModel(
      {required this.left,
      required this.top,
      required this.right,
      required this.bottom});

  factory RectModel.fromJson(Map<String, dynamic> json) =>
      _$RectModelFromJson(json);

  Map<String, dynamic> toJson() => _$RectModelToJson(this);
}
