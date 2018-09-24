class Comments {
  static const table = 'comments';
  static const tileIdCol = 'tileId';
  static const userIdCol = 'userId';
  static const commentCol = 'comment';
  static const timeStampCol = 'timeStamp';
  static const commentingUserIdCol = 'commentingUserId';

  String tileId;
  String userId;
  String comment;
  String timeStamp;
  String commentingUserId;

  Comments({
    this.tileId,
    this.userId,
    this.comment,
    this.timeStamp,
    this.commentingUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      tileIdCol: tileId,
      userIdCol: userId,
      commentCol: comment,
      timeStampCol: timeStamp,
      commentingUserIdCol: commentingUserId,
    };
  }

  Comments.fromMap(Map<String, dynamic> map)
      : this(
          tileId: map[tileIdCol],
          userId: map[userIdCol],
          comment: map[commentCol],
          timeStamp: map[timeStampCol],
          commentingUserId: map[commentingUserIdCol],
        );

  @override
  int get hashCode =>
      tileId.hashCode ^
      userId.hashCode ^
      comment.hashCode ^
      timeStamp.hashCode ^
      commentingUserId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comments &&
          runtimeType == other.runtimeType &&
          tileId == other.tileId &&
          userId == other.userId &&
          comment == other.comment &&
          timeStamp == other.timeStamp &&
          commentingUserId == other.commentingUserId;

  @override
  String toString() {
    return 'Comments{tileId: $tileId, userId: $userId, comment: $comment, timeStamp: $timeStamp, commentingUserId: $commentingUserId}';
  }
}
