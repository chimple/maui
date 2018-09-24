class ArticleTopic {
  static const table = 'articleTopic';
  static const articleIdCol = 'articleId';
  static const topicIdCol = 'topicId';

  String articleId;
  String topicId;

  ArticleTopic({this.articleId, this.topicId});

  Map<String, dynamic> toMap() {
    return {articleIdCol: articleId, topicIdCol: topicId};
  }

  ArticleTopic.fromMap(Map<String, dynamic> map)
      : this(articleId: map[articleIdCol], topicId: map[topicIdCol]);

  @override
  int get hashCode => articleIdCol.hashCode ^ topicIdCol.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleTopic &&
          runtimeType == other.runtimeType &&
          articleId == other.articleId &&
          topicId == other.topicId;
  @override
  String toString() {
    return 'ArticleTopic{id: $articleId, name: $topicId}';
  }
}
