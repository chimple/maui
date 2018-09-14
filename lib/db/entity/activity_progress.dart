class ActivityProgress {
  static const table = 'activityProgress';
  static const userIdCol = 'userId';
  static const topicIdCol = 'topicId';
  static const activityIdCol = 'activityId';

  String userId;
  String topicId;
  String activityId;

  ActivityProgress({
    this.userId,
    this.topicId,
    this.activityId,
  });

  Map<String, dynamic> toMap() {
    return {
      userIdCol: userId,
      topicIdCol: topicId,
      activityIdCol: activityId,
    };
  }

  ActivityProgress.fromMap(Map<String, dynamic> map)
      : this(
          userId: map[userIdCol],
          topicId: map[topicIdCol],
          activityId: map[activityIdCol],
        );

  @override
  int get hashCode => userId.hashCode ^ topicId.hashCode ^ activityId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityProgress &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          topicId == other.topicId &&
          activityId == other.activityId;

  @override
  String toString() {
    return 'ActivityProgresss{userId: $userId, topicId: $topicId, activityId: $activityId}';
  }
}
