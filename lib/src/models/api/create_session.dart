import 'package:json_annotation/json_annotation.dart';

part 'generated/create_session.g.dart';

@JsonSerializable()
class CreateSessionModel {
  Map<String, dynamic> capabilities;
  CreateSessionModel({required this.capabilities});

  factory CreateSessionModel.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSessionModelToJson(this);
}
