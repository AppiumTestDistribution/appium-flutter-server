
import 'package:json_annotation/json_annotation.dart';

part 'generated/set_text.g.dart';

@JsonSerializable()
class SetTextModal {
  String text;

  SetTextModal({required this.text});

  factory SetTextModal.fromJson(Map<String, dynamic> json) =>
      _$SetTextModalFromJson(json);

  Map<String, dynamic> toJson() => _$SetTextModalToJson(this);
}
