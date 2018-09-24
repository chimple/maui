class Home {
  static const table = 'home';
  static const userIdCol = 'userId';
  static const likesCol = 'likes';
  static const disLikesCol = 'disLikes';
  static const activityIdCol = 'activityId';
  static const topicIdCol = 'topicId';
  static const quizIdCol = 'quizId';
  static const articleIdCol = 'articleId';
  static const tileIdCol = 'tileId';

  String userId;
  int likes;
  int disLikes;
  String activityId;
  String topicId;
  String quizId;
  String articleId;
  String tileId;

  Home(
      {this.userId,
      this.activityId,
      this.articleId,
      this.disLikes,
      this.likes,
      this.quizId,
      this.tileId,
      this.topicId});

  Map<String, dynamic> toMap() {
    return {
      userIdCol: userId,
      tileIdCol: tileId,
      activityIdCol: activityId,
      topicIdCol: topicId,
      quizIdCol: quizId,
      likesCol: likes,
      disLikesCol: disLikes,
      articleIdCol: articleId,
    };
  }

  Home.fromMap(Map<String, dynamic> map)
      : this(
            userId: map[userIdCol],
            topicId: map[topicIdCol],
            activityId: map[activityIdCol],
            likes: map[likesCol],
            disLikes: map[disLikesCol],
            quizId: map[quizIdCol],
            articleId: map[articleIdCol],
            tileId: map[tileIdCol]);

  @override
  int get hashCode =>
      userId.hashCode ^
      likes.hashCode ^
      disLikes.hashCode ^
      topicId.hashCode ^
      activityId.hashCode ^
      articleId.hashCode ^
      quizId.hashCode ^
      tileId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Home &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          activityId == other.activityId &&
          articleId == other.articleId &&
          topicId == other.topicId &&
          quizId == other.quizId &&
          tileId == other.tileId &&
          likes == other.likes &&
          disLikes == other.disLikes;

  @override
  String toString() {
    return 'GameCategory{userId: $userId, activityId: $activityId, articleId: $articleId, topicId: $topicId, quizId: $quizId, tileId: $tileId, likes: $likes , disLikes: $disLikes}';
  }
}
