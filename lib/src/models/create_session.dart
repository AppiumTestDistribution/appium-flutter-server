import 'package:json_annotation/json_annotation.dart';

part 'generated/create_session.g.dart';

@JsonSerializable()
class CreateSession {
  Map<String, Object> capabilities;
  CreateSession(this.capabilities);

  factory CreateSession.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSessionToJson(this);
}
