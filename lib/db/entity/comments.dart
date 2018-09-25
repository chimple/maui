class Comments {
  static const table = 'comments';
  static const tileIdCol = 'tileId';
  static const commentCol = 'comment';
  static const timeStampCol = 'timeStamp';
  static const commentingUserIdCol = 'commentingUserId';

  String tileId;
  String comment;
  String timeStamp;
  String commentingUserId;

  Comments({
    this.tileId,
    this.comment,
    this.timeStamp,
    this.commentingUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      tileIdCol: tileId,
      commentCol: comment,
      timeStampCol: timeStamp,
      commentingUserIdCol: commentingUserId,
    };
  }

  Comments.fromMap(Map<String, dynamic> map)
      : this(
          tileId: map[tileIdCol],
          comment: map[commentCol],
          timeStamp: map[timeStampCol],
          commentingUserId: map[commentingUserIdCol],
        );

  @override
  int get hashCode =>
      tileId.hashCode ^
      comment.hashCode ^
      timeStamp.hashCode ^
      commentingUserId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comments &&
          runtimeType == other.runtimeType &&
          tileId == other.tileId &&
          comment == other.comment &&
          timeStamp == other.timeStamp &&
          commentingUserId == other.commentingUserId;

  @override
  String toString() {
    return 'Comments{tileId: $tileId, comment: $comment, timeStamp: $timeStamp, commentingUserId: $commentingUserId}';
  }
}
