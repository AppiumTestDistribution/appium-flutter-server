const W3C_ELEMENT_KEY = "element-6066-11e4-a52e-4f735466cecf";
const JWP_ELEMENT_KEY = "ELEMENT";

class ElementModel {
  String? jwpElementId;
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

  factory ElementModel.fromJson(Map<String, dynamic> json) => ElementModel(
        jwpElementId: json[JWP_ELEMENT_KEY] as String?,
        w3cElementId: json[W3C_ELEMENT_KEY] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        JWP_ELEMENT_KEY: jwpElementId,
        W3C_ELEMENT_KEY: w3cElementId,
      };
}
