import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'performance.g.dart';

abstract class Performance implements Built<Performance, PerformanceBuilder> {
  String get studentId;
  String get sessionId;
  String get title;
  int get numGames;
  int get score;
  BuiltList<SubScore> get subScores;
  DateTime get startTime;
  DateTime get endTime;

  Performance._();
  factory Performance([updates(PerformanceBuilder b)]) = _$Performance;
  static Serializer<Performance> get serializer => _$performanceSerializer;
}

abstract class SubScore implements Built<SubScore, SubScoreBuilder> {
  String get gameId;
  bool get complete;
  int get score;
  DateTime get startTime;
  DateTime get endTime;
  SubScore._();
  factory SubScore([updates(SubScoreBuilder b)]) = _$SubScore;
  static Serializer<SubScore> get serializer => _$subScoreSerializer;
}
