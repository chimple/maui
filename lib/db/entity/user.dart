import 'package:uuid/uuid.dart';

class User {
  static const table = 'user';
  static const columnId = 'id';
  static const columnDeviceId = 'deviceId';
  static const columnName = 'name';
  static const columnImage = 'image';
  static const columnCurrentLessonId = 'currentLessonId';
  static const ddl = '''
CREATE TABLE $table (
  $columnId TEXT PRIMARY KEY, 
  $columnDeviceId TEXT,
  $columnName TEXT, 
  $columnImage TEXT,
  $columnCurrentLessonId	INTEGER,
	FOREIGN KEY($columnCurrentLessonId) REFERENCES `lesson`(`id`))
''';

  String id;
  String deviceId;
  String name;
  String image;
  int currentLessonId;

  User({String id, this.deviceId, this.name, this.image, this.currentLessonId})
      : this.id = id ?? new Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnDeviceId: deviceId,
      columnName: name,
      columnImage: image,
      columnCurrentLessonId: currentLessonId
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : this(
            id: map[columnId],
            deviceId: map[columnDeviceId],
            name: map[columnName],
            image: map[columnImage],
            currentLessonId: map[columnCurrentLessonId]);

  @override
  int get hashCode =>
      id.hashCode ^
      deviceId.hashCode ^
      name.hashCode ^
      image.hashCode ^
      currentLessonId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          deviceId == other.deviceId &&
          name == other.name &&
          image == other.image &&
          currentLessonId == other.currentLessonId;

  @override
  String toString() {
    return 'User{id: $id, deviceId: $deviceId, name: $name, image: $image, currentLessonId: $currentLessonId}';
  }
}
