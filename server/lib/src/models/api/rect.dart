class RectModel {
  double left;
  double top;
  double right;
  double bottom;

  RectModel(
      {required this.left,
      required this.top,
      required this.right,
      required this.bottom});

  factory RectModel.fromJson(Map<String, dynamic> json) => RectModel(
        left: (json['left'] as num).toDouble(),
        top: (json['top'] as num).toDouble(),
        right: (json['right'] as num).toDouble(),
        bottom: (json['bottom'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
      };
}
