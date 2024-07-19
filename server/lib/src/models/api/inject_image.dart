class InjectImageModal {
  dynamic base64Image;

  InjectImageModal({this.base64Image});

  factory InjectImageModal.fromJson(Map<String, dynamic> json) => InjectImageModal(
        base64Image: json['base64Image'],
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'base64Image': base64Image};
}
