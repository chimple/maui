class RelatedTopic {
  static const table = 'relatedTopic';
  static const topicIdCol = 'topicId';
  static const relTopicIdCol = 'relatedTopicId';

  String id;
  String relId;

  RelatedTopic({this.id, this.relId});

  Map<String, dynamic> toMap() {
    return {topicIdCol: id, relTopicIdCol: relId};
  }

  RelatedTopic.fromMap(Map<String, dynamic> map)
      : this(
            id: map[topicIdCol],
            relId: map[relTopicIdCol]);

  @override
  int get hashCode =>
      id.hashCode ^ relId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelatedTopic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          relId == other.relId;

  @override
  String toString() {
    return 'RelatedTopic{id: $id, relId: $relId}';
  }
}
