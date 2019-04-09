import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'class_session.g.dart';

abstract class ClassSession
    implements Built<ClassSession, ClassSessionBuilder> {
  String get classId;
  String get name;
  String get teacherName;
  String get teacherPhoto;
  String get sessionId;

  ClassSession._();
  factory ClassSession([updates(ClassSessionBuilder b)]) = _$ClassSession;
  static Serializer<ClassSession> get serializer => _$classSessionSerializer;
}
