import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
part 'draw_convert.g.dart';


@JsonSerializable()
class CanvasProperty extends Object with _$CanvasPropertySerializerMixin{

  @JsonKey(nullable: false)
  List<Draw> draw= [];

  CanvasProperty(this.draw);

  factory CanvasProperty.fromJson(Map<String , dynamic> json) => _$CanvasPropertyFromJson(json);
}

@JsonSerializable()
class Draw extends Object with _$DrawSerializerMixin {
  int color;
  double width;

  @JsonKey(nullable: false)
  List<Position> position = [];

  Draw(this.color, this.width,
      {this.position});

  factory Draw.fromJson(Map<String, dynamic> json) => _$DrawFromJson(json);
}

@JsonSerializable(includeIfNull: false)
class Position extends Object with _$PositionSerializerMixin {
  double x = 0.0;
  double y = 0.0;

  Position(this.x , this.y);

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
}