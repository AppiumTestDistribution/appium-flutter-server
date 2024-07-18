class ActivateInjectImageModal {
  dynamic imageId;

  ActivateInjectImageModal({this.imageId});

  factory ActivateInjectImageModal.fromJson(Map<String, dynamic> json) => ActivateInjectImageModal(
         imageId: json['imageId'],
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'imageId': imageId};
}
