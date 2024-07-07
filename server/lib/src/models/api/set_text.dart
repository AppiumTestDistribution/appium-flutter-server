class SetTextModal {
  dynamic text;
  List<dynamic> value;

  SetTextModal({this.text, required this.value});

  factory SetTextModal.fromJson(Map<String, dynamic> json) => SetTextModal(
        text: json['text'],
        value: json['value'] as List<dynamic>,
      );

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'text': text, 'value': value};
}
