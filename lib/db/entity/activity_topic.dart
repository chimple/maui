class ActivityTopic {
  static const table = 'activityTopic';
  static const activityIdCol = 'activityId';
  static const topicIdCol = 'topicId';

  String activityId;
  String topicId;

  ActivityTopic({this.activityId, this.topicId});

  Map<String, dynamic> toMap() {
    return {activityIdCol: activityId, topicIdCol: topicId};
  }

  ActivityTopic.fromMap(Map<String, dynamic> map)
      : this(activityId: map[activityIdCol], topicId: map[topicIdCol]);

  @override
  int get hashCode => activityIdCol.hashCode ^ topicIdCol.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTopic &&
          runtimeType == other.runtimeType &&
          activityId == other.activityId &&
          topicId == other.topicId;
  @override
  String toString() {
    return 'ActivityTopic{id: $activityId, name: $topicId}';
  }
}
