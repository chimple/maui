import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/quiz_update.dart';

part 'class_session.g.dart';

abstract class ClassSession
    implements Built<ClassSession, ClassSessionBuilder> {
  String get classId;
  String get teacherId;
  String get sessionId;
  StatusEnum get status;

  ClassSession._();
  factory ClassSession([updates(ClassSessionBuilder b)]) = _$ClassSession;
  static Serializer<ClassSession> get serializer => _$classSessionSerializer;
}
