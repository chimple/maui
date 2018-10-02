class Home {
  static const table = 'home';
  static const userIdCol = 'userId';
  static const typeCol = 'type';
  static const typeIdCol = 'typeId';
  static const tileIdCol = 'tileId';

  String userId;
  String type;
  String typeId;
  String tileId;

  Home({this.userId, this.typeId, this.type, this.tileId});

  Map<String, dynamic> toMap() {
    return {
      userIdCol: userId,
      tileIdCol: tileId,
      typeCol: type,
      typeIdCol: typeId,
    };
  }

  Home.fromMap(Map<String, dynamic> map)
      : this(
            userId: map[userIdCol],
            type: map[typeCol],
            typeId: map[typeIdCol],
            tileId: map[tileIdCol]);

  @override
  int get hashCode =>
      userId.hashCode ^ type.hashCode ^ typeId.hashCode ^ tileId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Home &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          tileId == other.tileId &&
          type == other.type &&
          typeId == other.typeId;

  @override
  String toString() {
    return 'Home{userId: $userId, tileId: $tileId, type: $type , typeId: $typeId}';
  }
}
