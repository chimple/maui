import 'package:maui/db/entity/user.dart';

class Comment {
  static const table = 'comment';

  static const idCol = 'id';
  static const parentIdCol = 'parentId';
  static const commentCol = 'comment';
  static const timeStampCol = 'timeStamp';
  static const userIdCol = 'userId';

  static const idSel = '${table}_id';
  static const parentIdSel = '${table}_parentId';
  static const commentSel = '${table}_comment';
  static const timeStampSel = '${table}_timeStamp';
  static const userIdSel = '${table}_userId';

  static const List<String> allCols = [
    '$table.$idCol AS $idSel',
    '$table.$parentIdCol AS $parentIdSel',
    '$table.$commentCol AS $commentSel',
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
  String comment;
  DateTime timeStamp;
  String userId;
  User user;

  Comment(
      {this.id,
      this.parentId,
      this.comment,
      this.timeStamp,
      this.userId,
      this.user});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      parentIdCol: parentId,
      commentCol: comment,
      timeStampCol: timeStamp.millisecondsSinceEpoch,
      userIdCol: userId,
    };
  }

  Comment.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idSel],
            parentId: map[parentIdSel],
            comment: map[commentSel],
            timeStamp: DateTime.fromMicrosecondsSinceEpoch(map[timeStampSel]),
            userId: map[userIdSel],
            user: User.fromMap(map));

  @override
  int get hashCode =>
      id.hashCode ^
      parentId.hashCode ^
      comment.hashCode ^
      timeStamp.hashCode ^
      userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          parentId == other.parentId &&
          comment == other.comment &&
          timeStamp == other.timeStamp &&
          userId == other.userId;

  @override
  String toString() {
    return '''TileComment{id: $id, parentId: $parentId, comment: $comment, timeStamp: $timeStamp, userId: $userId}
user: $user
''';
  }
}
