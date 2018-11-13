import 'package:maui/db/entity/user.dart';

class Like {
  static const table = 'comment';

  static const idCol = 'id';
  static const parentIdCol = 'parentId';
  static const typeCol = 'type';
  static const timeStampCol = 'timeStamp';
  static const userIdCol = 'userId';

  static const idSel = '${table}_id';
  static const parentIdSel = '${table}_parentId';
  static const typeSel = '${table}_type';
  static const timeStampSel = '${table}_timeStamp';
  static const userIdSel = '${table}_userId';

  static const List<String> allCols = [
    '$table.$idCol AS $idSel',
    '$table.$parentIdCol AS $parentIdSel',
    '$table.$typeCol AS $typeSel',
    '$table.$timeStampCol AS $timeStampSel',
    '$table.$userIdCol AS $userIdSel',
    '${User.table}.${User.idCol} AS ${User.idSel}',
    '${User.table}.${User.deviceIdCol} AS ${User.deviceIdSel}',
    '${User.table}.${User.nameCol} AS ${User.nameSel}',
    '${User.table}.${User.colorCol} AS ${User.colorSel}',
    '${User.table}.${User.imageCol} AS ${User.imageSel}',
    '${User.table}.${User.pointsCol} AS ${User.pointsSel}',
    '${User.table}.${User.currentLessonIdCol} AS ${User.currentLessonIdSel}'
  ];

  String id;
  String parentId;
  int type;
  DateTime timeStamp;
  String userId;
  User user;

  Like(
      {this.id,
      this.parentId,
      this.type,
      this.timeStamp,
      this.userId,
      this.user});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      parentIdCol: parentId,
      typeCol: type,
      timeStampCol: timeStamp.millisecondsSinceEpoch,
      userIdCol: userId,
    };
  }

  Like.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idSel],
            parentId: map[parentIdSel],
            type: map[typeSel],
            timeStamp: DateTime.fromMicrosecondsSinceEpoch(map[timeStampSel]),
            userId: map[userIdSel],
            user: User.fromMap(map));

  @override
  int get hashCode =>
      id.hashCode ^
      parentId.hashCode ^
      type.hashCode ^
      timeStamp.hashCode ^
      userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Like &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          parentId == other.parentId &&
          type == other.type &&
          timeStamp == other.timeStamp &&
          userId == other.userId;

  @override
  String toString() {
    return '''Like{id: $id, parentId: $parentId, type: $type, timeStamp: $timeStamp, userId: $userId}
user: $user
''';
  }
}
