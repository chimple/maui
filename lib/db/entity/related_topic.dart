class RelatedTopic {
  static const table = 'relatedTopic';
  static const topicIdCol = 'topicId';
  static const relTopicIdCol = 'relatedTopicId';

  String topicId;
  String relatedTopicId;

  RelatedTopic({this.topicId, this.relatedTopicId});

  Map<String, dynamic> toMap() {
    return {topicIdCol: topicId, relTopicIdCol: relatedTopicId};
  }

  RelatedTopic.fromMap(Map<String, dynamic> map)
      : this(topicId: map[topicIdCol], relatedTopicId: map[relTopicIdCol]);

  @override
  int get hashCode => topicId.hashCode ^ relatedTopicId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelatedTopic &&
          runtimeType == other.runtimeType &&
          topicId == other.topicId &&
          relatedTopicId == other.relatedTopicId;

  @override
  String toString() {
    return 'RelatedTopic{topicId: $topicId, relatedTopicId: $relatedTopicId}';
  }
}
