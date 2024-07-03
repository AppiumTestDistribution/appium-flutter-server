class SetTextModal {
  String text;

  SetTextModal({required this.text});

  factory SetTextModal.fromJson(Map<String, dynamic> json) => SetTextModal(
        text: json['text'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
      };
}
