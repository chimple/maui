class TileComment {
  static const table = 'tileComment';
  static const idCol = 'id';
  static const tileIdCol = 'tileId';
  static const commentCol = 'comment';
  static const timeStampCol = 'timeStamp';
  static const userIdCol = 'userId';

  static const List<String> allCols = [
    idCol,
    tileIdCol,
    commentCol,
    timeStampCol,
    userIdCol
  ];

  String id;
  String tileId;
  String comment;
  String timeStamp;
  String userId;

  TileComment({
    this.id,
    this.tileId,
    this.comment,
    this.timeStamp,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      tileIdCol: tileId,
      commentCol: comment,
      timeStampCol: timeStamp,
      userIdCol: userId,
    };
  }

  TileComment.fromMap(Map<String, dynamic> map)
      : this(
          id: map[idCol],
          tileId: map[tileIdCol],
          comment: map[commentCol],
          timeStamp: map[timeStampCol],
          userId: map[userIdCol],
        );

  @override
  int get hashCode =>
      id.hashCode ^
      tileId.hashCode ^
      comment.hashCode ^
      timeStamp.hashCode ^
      userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TileComment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          tileId == other.tileId &&
          comment == other.comment &&
          timeStamp == other.timeStamp &&
          userId == other.userId;

  @override
  String toString() {
    return 'TileComment{id: $id, tileId: $tileId, comment: $comment, timeStamp: $timeStamp, userId: $userId}';
  }
}
