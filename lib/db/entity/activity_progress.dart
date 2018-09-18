class ActivityProgress {
  static const table = 'activityProgress';
  static const timeStampIdCol = 'timeStampId';
  static const userIdCol = 'userId';
  static const topicIdCol = 'topicId';
  static const activityIdCol = 'activityId';

  String userId;
  String topicId;
  String activityId;
  String timeStampId;

  ActivityProgress(
      {this.userId, this.topicId, this.activityId, this.timeStampId});

  Map<String, dynamic> toMap() {
    return {
      userIdCol: userId,
      topicIdCol: topicId,
      activityIdCol: activityId,
      timeStampIdCol: timeStampId
    };
  }

  ActivityProgress.fromMap(Map<String, dynamic> map)
      : this(
          userId: map[userIdCol],
          topicId: map[topicIdCol],
          activityId: map[activityIdCol],
          timeStampId: map[timeStampIdCol],
        );

  @override
  int get hashCode =>
      userId.hashCode ^
      topicId.hashCode ^
      activityId.hashCode ^
      timeStampId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityProgress &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          topicId == other.topicId &&
          activityId == other.activityId &&
          timeStampId == other.timeStampId;

  @override
  String toString() {
    return 'ActivityProgresss{userId: $userId, topicId: $topicId, activityId: $activityId, timeStampId: $timeStampId}';
  }
}
