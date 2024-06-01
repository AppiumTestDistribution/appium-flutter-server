import 'package:json_annotation/json_annotation.dart';

part 'generated/element.g.dart';

@JsonSerializable()
class ElementModel {
  @JsonKey(name: "ELEMENT")
  String? jwpElementId;

  @JsonKey(name: "element-6066-11e4-a52e-4f735466cecf")
  String? w3cElementId;

  ElementModel({
    required this.jwpElementId,
    required this.w3cElementId,
  });

  ElementModel.fromElement(String elementId) {
    jwpElementId = elementId;
    w3cElementId = elementId;
  }

  String get id {
    return jwpElementId == null ? w3cElementId! : jwpElementId!;
  }

  factory ElementModel.fromJson(Map<String, dynamic> json) =>
      _$ElementModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElementModelToJson(this);
}
