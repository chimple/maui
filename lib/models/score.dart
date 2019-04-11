import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'score.g.dart';

abstract class Score implements Built<Score, ScoreBuilder> {
  String get studentId;
  String get gameId;
  String get sessionId;
  int get score;
  int get max;
  int get level;
  DateTime get startTime;
  DateTime get endTime;

  Score._();
  factory Score([updates(ScoreBuilder b)]) = _$Score;
  static Serializer<Score> get serializer => _$scoreSerializer;
}
