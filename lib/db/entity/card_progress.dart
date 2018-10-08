class CardProgress {
  static const table = 'cardProgress';
  static const userIdCol = 'userId';
  static const cardIdCol = 'cardId';
  static const updatedAtCol = 'updatedAt';
  static const maxScoreCol = 'maxScore';
  static const outOfTotalCol = 'outOfTotal';

  static const allCols = [
    userIdCol,
    cardIdCol,
    updatedAtCol,
    maxScoreCol,
    outOfTotalCol
  ];

  static const allPrefixedCols = [
    '$table.$userIdCol',
    '$table.$cardIdCol',
    '$table.$updatedAtCol',
    '$table.$maxScoreCol',
    '$table.$outOfTotalCol'
  ];

  String userId;
  String cardId;
  DateTime updatedAt;
  int maxScore;
  int outOfTotal;

  CardProgress(
      {this.userId,
      this.cardId,
      this.updatedAt,
      this.maxScore,
      this.outOfTotal});

  Map<String, dynamic> toMap() {
    return {
      userIdCol: userId,
      cardIdCol: cardId,
      updatedAtCol: updatedAt.millisecondsSinceEpoch,
      maxScoreCol: maxScore,
      outOfTotalCol: outOfTotal
    };
  }

  CardProgress.fromMap(Map<String, dynamic> map)
      : this(
            userId: map[userIdCol],
            cardId: map[cardIdCol],
            updatedAt: DateTime.fromMillisecondsSinceEpoch(map[updatedAtCol]),
            maxScore: map[maxScoreCol],
            outOfTotal: map[outOfTotalCol]);

  @override
  int get hashCode =>
      userId.hashCode ^
      cardId.hashCode ^
      updatedAt.hashCode ^
      maxScore.hashCode ^
      outOfTotal.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardProgress &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          cardId == other.cardId &&
          updatedAt == other.updatedAt &&
          maxScore == other.maxScore &&
          outOfTotal == other.outOfTotal;

  @override
  String toString() {
    return 'QuizProgresss{userId: $userId, cardId: $cardId, updatedAt: $updatedAt, maxScore: $maxScore, outOfTotal: $outOfTotal}';
  }
}
