class CardComment {
  static const table = 'cardComment';
  static const idCol = 'id';
  static const cardIdCol = 'cardId';
  static const commentCol = 'comment';
  static const timeStampCol = 'timeStamp';
  static const userIdCol = 'userId';

  static const List<String> allCols = [
    idCol,
    cardIdCol,
    commentCol,
    timeStampCol,
    userIdCol
  ];

  String id;
  String cardId;
  String comment;
  String timeStamp;
  String userId;

  CardComment({
    this.id,
    this.cardId,
    this.comment,
    this.timeStamp,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      cardIdCol: cardId,
      commentCol: comment,
      timeStampCol: timeStamp,
      userIdCol: userId,
    };
  }

  CardComment.fromMap(Map<String, dynamic> map)
      : this(
          id: map[idCol],
          cardId: map[cardIdCol],
          comment: map[commentCol],
          timeStamp: map[timeStampCol],
          userId: map[userIdCol],
        );

  @override
  int get hashCode =>
      id.hashCode ^
      cardId.hashCode ^
      comment.hashCode ^
      timeStamp.hashCode ^
      userId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardComment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cardId == other.cardId &&
          comment == other.comment &&
          timeStamp == other.timeStamp &&
          userId == other.userId;

  @override
  String toString() {
    return 'CardComment{id: $id, cardId: $cardId, comment: $comment, timeStamp: $timeStamp, userId: $userId}';
  }
}
