import 'package:uuid/uuid.dart';

class User {
  static const table = 'user';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnImage = 'image';
  static const columnCurrentLessonId = 'currentLessonId';
  static const ddl = '''
CREATE TABLE $table (
  $columnId TEXT PRIMARY KEY, 
  $columnName TEXT, 
  $columnImage TEXT,
  $columnCurrentLessonId	INTEGER,
	FOREIGN KEY($columnCurrentLessonId) REFERENCES `lesson`(`id`))
''';

  String id;
  String name;
  String image;
  int currentLessonId;

  User({String id, this.name, this.image, this.currentLessonId})
      : this.id = id ?? new Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnName: name,
      columnImage: image,
      columnCurrentLessonId: currentLessonId
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : this(
            id: map[columnId],
            name: map[columnName],
            image: map[columnImage],
            currentLessonId: map[columnCurrentLessonId]);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ image.hashCode ^ currentLessonId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          currentLessonId == other.currentLessonId;

  @override
  String toString() {
    return 'User{id: $id, name: $name, image: $image, currentLessonId: $currentLessonId}';
  }
}
