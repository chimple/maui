import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/performance.dart';

part 'quiz_update.g.dart';

abstract class QuizUpdate implements Built<QuizUpdate, QuizUpdateBuilder> {
  String get sessionId;
  StatusEnum get status;

  @nullable
  BuiltList<Performance> get performances;

  QuizUpdate._();
  factory QuizUpdate([updates(QuizUpdateBuilder b)]) = _$QuizUpdate;
  static Serializer<QuizUpdate> get serializer => _$quizUpdateSerializer;
}

class StatusEnum extends EnumClass {
  static Serializer<StatusEnum> get serializer => _$statusEnumSerializer;

  static const StatusEnum create = _$create;
  static const StatusEnum start = _$start;
  static const StatusEnum progress = _$progress;
  static const StatusEnum end = _$end;

  const StatusEnum._(String name) : super(name);

  static BuiltSet<StatusEnum> get values => _$values;
  static StatusEnum valueOf(String name) => _$valueOf(name);
}
