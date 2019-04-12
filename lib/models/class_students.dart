import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:maui/models/student.dart';

part 'class_students.g.dart';

abstract class ClassStudents
    implements Built<ClassStudents, ClassStudentsBuilder> {
  String get classId;
  String get sessionId;
  BuiltList<Student> get students;

  ClassStudents._();
  factory ClassStudents([updates(ClassStudentsBuilder b)]) = _$ClassStudents;
  static Serializer<ClassStudents> get serializer => _$classStudentsSerializer;
}
