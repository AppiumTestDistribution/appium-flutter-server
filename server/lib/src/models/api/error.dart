class ErrorModel {
  String error;
  String message;
  String? stackTrace;

  ErrorModel({required this.error, required this.message, this.stackTrace});

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        error: json['error'] as String,
        message: json['message'] as String,
        stackTrace: json['stackTrace'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'error': error,
        'message': message,
        'stackTrace': stackTrace,
      };
}
