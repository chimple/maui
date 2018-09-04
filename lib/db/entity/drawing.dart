class Drawing {
  static const table = 'drawing';
  static const idCol = 'id';
  static const activityIdCol = 'activityId';
  static const jsonCol = 'json';
  static const thumbnailImageIdCol = 'thumbnailImageId';
  static const createdAtCol = 'createdAt';
  static const userIdCol = 'userId';
  static const updatedAtCol = 'updatedAt';

  static const allCols = [
    idCol,
    activityIdCol,
    jsonCol,
    thumbnailImageIdCol,
    userIdCol,
    createdAtCol,
    updatedAtCol
  ];

  String id;
  String activityId;
  String json;
  String thumbnailImageId;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;

  Drawing(
      {this.id,
      this.activityId,
      this.json,
      this.thumbnailImageId,
      this.createdAt,
      this.userId,
      this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      activityIdCol: activityId,
      jsonCol: json,
      thumbnailImageIdCol: thumbnailImageId,
      userIdCol: userId,
      createdAtCol: createdAt.millisecondsSinceEpoch,
      updatedAtCol: updatedAt.millisecondsSinceEpoch
    };
  }

  Drawing.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            activityId: map[activityIdCol],
            json: map[jsonCol],
            thumbnailImageId: map[thumbnailImageIdCol],
            userId: map[userIdCol],
            createdAt: DateTime.fromMillisecondsSinceEpoch(map[createdAtCol]),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(map[updatedAtCol]));

  @override
  int get hashCode =>
      id.hashCode ^
      activityId.hashCode ^
      json.hashCode ^
      thumbnailImageId.hashCode ^
      userId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Drawing &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          activityId == other.activityId &&
          json == other.json &&
          thumbnailImageId == other.thumbnailImageId &&
          userId == other.userId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  String toString() {
    return 'Drawing{id: $id, activityId: $activityId, json: $json, thumbnailImageId: $thumbnailImageId, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
