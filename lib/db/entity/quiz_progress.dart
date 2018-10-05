class QuizProgress {
  static const table = 'quizProgress';
  static const idCol = 'id';
  static const userIdCol = 'userId';
  static const topicIdCol = 'topicId';
  static const quizIdCol = 'quizId';
  static const maxScoreCol = 'maxScore';
  static const outOfTotalCol = 'outOfTotal';

  String id;
  String userId;
  String topicId;
  String quizId;
  int maxScore;
  int outOfTotal;

  QuizProgress(
      {this.id,
      this.userId,
      this.topicId,
      this.quizId,
      this.maxScore,
      this.outOfTotal});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      userIdCol: userId,
      topicIdCol: topicId,
      quizIdCol: quizId,
      maxScoreCol: maxScore,
      outOfTotalCol: outOfTotal
    };
  }

  QuizProgress.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            userId: map[userIdCol],
            topicId: map[topicIdCol],
            quizId: map[quizIdCol],
            maxScore: map[maxScoreCol],
            outOfTotal: map[outOfTotalCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      topicId.hashCode ^
      quizId.hashCode ^
      maxScore.hashCode ^
      outOfTotal.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizProgress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          topicId == other.topicId &&
          quizId == other.quizId &&
          maxScore == other.maxScore &&
          outOfTotal == other.outOfTotal;

  @override
  String toString() {
    return 'QuizProgresss{id: $id, userId: $userId, topicId: $topicId, quizId: $quizId, maxScore: $maxScore, outOfTotal: $outOfTotal}';
  }
}
