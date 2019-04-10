import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'student.g.dart';

abstract class Student implements Built<Student, StudentBuilder> {
  String get id;
  String get name;
  String get grade;
  String get photo;

  Student._();
  factory Student([updates(StudentBuilder b)]) = _$Student;
  static Serializer<Student> get serializer => _$studentSerializer;
}
