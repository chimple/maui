class Drawing {
  static const table = 'drawing';
  static const idCol = 'id';
  static const activityIdCol = 'activityId';
  static const jsonCol = 'json';
  static const thumbnailImageCol = 'thumbnailImage';
  static const createdAtCol = 'createdAt';
  static const userIdCol = 'userId';
  static const updatedAtCol = 'updatedAt';

  static const allCols = [
    idCol,
    activityIdCol,
    jsonCol,
    thumbnailImageCol,
    userIdCol,
    createdAtCol,
    updatedAtCol
  ];

  String id;
  String activityId;
  String json;
  String thumbnailImage;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;

  Drawing(
      {this.id,
      this.activityId,
      this.json,
      this.thumbnailImage,
      this.createdAt,
      this.userId,
      this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      activityIdCol: activityId,
      jsonCol: json,
      thumbnailImageCol: thumbnailImage,
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
            thumbnailImage: map[thumbnailImageCol],
            userId: map[userIdCol],
            createdAt: DateTime.fromMillisecondsSinceEpoch(map[createdAtCol]),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(map[updatedAtCol]));

  @override
  int get hashCode =>
      id.hashCode ^
      activityId.hashCode ^
      json.hashCode ^
      thumbnailImage.hashCode ^
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
          thumbnailImage == other.thumbnailImage &&
          userId == other.userId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  String toString() {
    return 'Drawing{id: $id, activityId: $activityId, json: $json, thumbnailImage: $thumbnailImage, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
