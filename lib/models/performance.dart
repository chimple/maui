import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'performance.g.dart';

abstract class Performance implements Built<Performance, PerformanceBuilder> {
  String get studentId;
  String get gameId;
  String get sessionId;
  int get level;
  String get question;
  String get answer;
  bool get correct;
  int get score;
  int get total;
  DateTime get startTime;
  DateTime get endTime;
  Performance._();
  factory Performance([updates(PerformanceBuilder b)]) = _$Performance;
  static Serializer<Performance> get serializer => _$performanceSerializer;
}
