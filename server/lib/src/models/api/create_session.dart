class CreateSessionModel {
  Map<String, dynamic>? capabilities;
  CreateSessionModel({required this.capabilities});

  factory CreateSessionModel.fromJson(Map<String, dynamic> json) =>
      CreateSessionModel(
        capabilities: json['capabilities'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'capabilities': capabilities,
      };
}
