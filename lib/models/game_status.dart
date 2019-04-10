library game_status;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'game_status.g.dart';

abstract class GameStatus implements Built<GameStatus, GameStatusBuilder> {
  int get currentLevel;
  int get highestLevel;
  int get maxScore;
  bool get open;

  GameStatus._();
  factory GameStatus([updates(GameStatusBuilder b)]) = _$GameStatus;
  static Serializer<GameStatus> get serializer => _$gameStatusSerializer;
}
