import 'lesson.dart';
import 'unit.dart';

class LessonUnit {
  static const table = 'lessonUnit';
  static const idCol = 'id';
  static const lessonIdCol = 'lessonId';
  static const seqCol = 'seq';
  static const subjectUnitIdCol = 'subjectUnitId';
  static const objectUnitIdCol = 'objectUnitId';
  static const highlightCol = 'highlight';
  static const ddl = '''
CREATE TABLE $table (
  $idCol INTEGER PRIMARY KEY, 
  $lessonIdCol INTEGER, 
  $seqCol INTEGER, 
  $subjectUnitIdCol TEXT, 
  $objectUnitIdCol TEXT, 
  $highlightCol TEXT,
  FOREIGN KEY ($lessonIdCol) REFERENCES ${Lesson.table}(${Lesson.idCol}),
--  FOREIGN KEY ($subjectUnitIdCol) REFERENCES ${Unit.table}(${Unit.idCol}),
--  FOREIGN KEY ($objectUnitIdCol) REFERENCES ${Unit.table}(${Unit.idCol}))
''';

  int id;
  int lessonId;
  int seq;
  String subjectUnitId;
  String objectUnitId;
  String highlight;

  LessonUnit(
      {this.id,
      this.lessonId,
      this.seq,
      this.subjectUnitId,
      this.objectUnitId,
      this.highlight});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      lessonIdCol: lessonId,
      seqCol: seq,
      subjectUnitIdCol: subjectUnitId,
      objectUnitIdCol: objectUnitId,
      highlightCol: highlight
    };
  }

  LessonUnit.fromMap(Map<String, dynamic> map, {String prefix = ''})
      : this(
            id: map[prefix+idCol],
            lessonId: map[prefix+lessonIdCol],
            seq: map[prefix+seqCol],
            subjectUnitId: map[prefix+subjectUnitIdCol],
            objectUnitId: map[prefix+objectUnitIdCol],
            highlight: map[prefix+highlightCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      lessonId.hashCode ^
      seq.hashCode ^
      subjectUnitId.hashCode ^
      objectUnitId.hashCode ^
      highlight.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonUnit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          lessonId == other.lessonId &&
          seq == other.seq &&
          subjectUnitId == other.subjectUnitId &&
          objectUnitId == other.objectUnitId &&
          highlight == other.highlight;

  @override
  String toString() {
    return 'LessonUnit{id: $id, lessonId: $lessonId, seq: $seq, subjectUnitId: $subjectUnitId, objectUnitId: $objectUnitId, highlight: $highlight}';
  }
}
