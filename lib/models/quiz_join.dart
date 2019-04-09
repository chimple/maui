import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'quiz_join.g.dart';

abstract class QuizJoin implements Built<QuizJoin, QuizJoinBuilder> {
  String get sessionId;
  String get studentId;

  QuizJoin._();
  factory QuizJoin([updates(QuizJoinBuilder b)]) = _$QuizJoin;
  static Serializer<QuizJoin> get serializer => _$quizJoinSerializer;
}
