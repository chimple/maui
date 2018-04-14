// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draw_convert.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

CanvasProperty _$CanvasPropertyFromJson(Map<String, dynamic> json) =>
    new CanvasProperty((json['draw'] as List)
        .map((e) => new Draw.fromJson(e as Map<String, dynamic>))
        .toList());

abstract class _$CanvasPropertySerializerMixin {
  List<Draw> get draw;
  Map<String, dynamic> toJson() => <String, dynamic>{'draw': draw};
}

Draw _$DrawFromJson(Map<String, dynamic> json) =>
    new Draw(json['color'] as int, (json['width'] as num)?.toDouble(),
        position: (json['position'] as List)
            .map((e) => new Position.fromJson(e as Map<String, dynamic>))
            .toList());

abstract class _$DrawSerializerMixin {
  int get color;
  double get width;
  List<Position> get position;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'color': color, 'width': width, 'position': position};
}

Position _$PositionFromJson(Map<String, dynamic> json) => new Position(
    (json['x'] as num)?.toDouble(), (json['y'] as num)?.toDouble());

abstract class _$PositionSerializerMixin {
  double get x;
  double get y;
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('x', x);
    writeNotNull('y', y);
    return val;
  }
}
