import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'class_interest.g.dart';

abstract class ClassInterest
    implements Built<ClassInterest, ClassInterestBuilder> {
  String get sessionId;

  ClassInterest._();
  factory ClassInterest([updates(ClassInterestBuilder b)]) = _$ClassInterest;
  static Serializer<ClassInterest> get serializer => _$classInterestSerializer;
}
