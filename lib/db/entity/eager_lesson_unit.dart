import 'unit.dart';
import 'lesson_unit.dart';

class EagerLessonUnit {
  LessonUnit lessonUnit;
  Unit subjectUnit;
  Unit objectUnit;

  EagerLessonUnit({this.lessonUnit, this.subjectUnit, this.objectUnit});

  EagerLessonUnit.fromMap(Map<String, dynamic> map)
  : this(
    lessonUnit: new LessonUnit.fromMap(map),
    subjectUnit: new Unit.fromMap(map, prefix: 'su_'),
    objectUnit: new Unit.fromMap(map, prefix: 'ou_')
  );

  @override
  int get hashCode =>
      lessonUnit.hashCode ^
      subjectUnit.hashCode ^
      objectUnit.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EagerLessonUnit &&
              runtimeType == other.runtimeType &&
              lessonUnit == other.lessonUnit &&
              subjectUnit == other.subjectUnit &&
              objectUnit == other.objectUnit;

  @override
  String toString() {
    return 'EagerLessonUnit{lessonUnit: $lessonUnit, subjectUnit: $subjectUnit, objectUnit: $objectUnit}';
  }

}