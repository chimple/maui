library game_config;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_config.g.dart';

abstract class GameConfig implements Built<GameConfig, GameConfigBuilder> {
  String get name;
  String get image;
  int get levels;

  GameConfig._();
  factory GameConfig([updates(GameConfigBuilder b)]) = _$GameConfig;
  static Serializer<GameConfig> get serializer => _$gameConfigSerializer;
}
