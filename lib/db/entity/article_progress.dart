class ArticleProgress {
  static const table = 'articleProgress';
  static const idCol = 'id';
  static const userIdCol = 'userId';
  static const topicIdCol = 'topicId';
  static const articleIdCol = 'articleId';
  static const timeStampIdCol = 'timeStampId';

  String id;
  String userId;
  String topicId;
  String articleId;
  String timeStampId;

  ArticleProgress(
      {this.id, this.userId, this.topicId, this.articleId, this.timeStampId});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      userIdCol: userId,
      topicIdCol: topicId,
      articleIdCol: articleId,
      timeStampIdCol: timeStampId
    };
  }

  ArticleProgress.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            userId: map[userIdCol],
            topicId: map[topicIdCol],
            articleId: map[articleIdCol],
            timeStampId: map[timeStampIdCol]);

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ topicId.hashCode ^ articleId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleProgress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          topicId == other.topicId &&
          articleId == other.articleId &&
          timeStampId == other.timeStampId;

  @override
  String toString() {
    return 'QuizProgresss{id: $id, userId: $userId, topicId: $topicId, quizId: $articleId, timeStampId: $timeStampId}';
  }
}
