class PointModel {
  double x;
  double y;

  PointModel({required this.x, required this.y});

  factory PointModel.fromJson(Map<String, dynamic> json) => PointModel(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'x': x,
        'y': y,
      };
}
