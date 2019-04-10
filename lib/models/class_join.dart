import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'class_join.g.dart';

abstract class ClassJoin implements Built<ClassJoin, ClassJoinBuilder> {
  String get sessionId;
  String get studentId;

  ClassJoin._();
  factory ClassJoin([updates(ClassJoinBuilder b)]) = _$ClassJoin;
  static Serializer<ClassJoin> get serializer => _$classJoinSerializer;
}
