import 'package:uuid/uuid.dart';
import 'dart:math';

final Map<int, int> userColors = {
  0xFF48AECC: 0xFFffb300,
  0xFFAD85F9: 0xFFFFB300,
  0xFF52C5CE: 0xFFFAFAFA,
  0xFFFFCE73: 0xFFff80ab,
  0xFFD64C60: 0xFF734052,
  0xFFEB706F: 0xFFa9b78a,
  0xFFA1EF6F: 0xFF7592BC,
  0xFF57DBFF: 0xFFe27329,
  0xFFFF8481: 0xFF76abd3,
  0xFF56EDE6: 0xFFD32F2F,
  0xFFEDC23B: 0xFFef4822,
  0xFF66488C: 0xFFffb300,
  0xFFDD6154: 0xFFa3bc8b,
  0xFF77DB65: 0xFFe58a28,
  0xFFA292FF: 0xFF9b671b,
  0xFFDD4785: 0xFFEFEFEF,
  0xFFFF7676: 0xFFffffca,
  0xFFE66796: 0xFF75F2F2,
  0xFF35C9C1: 0xFFed4a79,
  0xFF30C9E2: 0xFFFFF176,
  0xFFA46DBA: 0xFFFF812C,
  0xFF42AD56: 0xFFffdc48,
  0xFFF47C5D: 0xFF30d858,
  0xFFF97658: 0xFF18c9c0,
  0xFFFF7D8F: 0xFFDAECF7,
  0xFF1DC8CC: 0xFF282828
};

class User {
  static const table = 'user';
  static const columnId = 'id';
  static const columnDeviceId = 'deviceId';
  static const columnName = 'name';
  static const columnColor = 'color';
  static const columnImage = 'image';
  static const columnCurrentLessonId = 'currentLessonId';
  static const botId = 'bot';

  String id;
  String deviceId;
  String name;
  int color;
  String image;
  int currentLessonId;

  User(
      {String id,
      this.deviceId,
      String name,
      int color,
      this.image,
      this.currentLessonId})
      : this.id = id ?? new Uuid().v4(),
        this.color = color ??
            userColors.entries
                .elementAt(Random().nextInt(userColors.length))
                .key,
        this.name = name?.replaceAll('*', ' ');

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnDeviceId: deviceId,
      columnName: name,
      columnColor: color,
      columnImage: image,
      columnCurrentLessonId: currentLessonId
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : this(
            id: map[columnId],
            deviceId: map[columnDeviceId],
            name: map[columnName],
            color: map[columnColor],
            image: map[columnImage],
            currentLessonId: map[columnCurrentLessonId]);

  @override
  int get hashCode =>
      id.hashCode ^
      deviceId.hashCode ^
      name.hashCode ^
      color.hashCode ^
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
          color == other.color &&
          image == other.image &&
          currentLessonId == other.currentLessonId;

  @override
  String toString() {
    return 'User{id: $id, deviceId: $deviceId, name: $name, color: $color, image: $image, currentLessonId: $currentLessonId}';
  }
}
