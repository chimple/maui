class Notif {
  static const table = 'notif';
  static const userIdCol = 'userId';
  static const typeCol = 'type';
  static const numNotifsCol = 'numNotifs';

  String userId;
  String type;
  int numNotifs;

  Notif({this.userId, this.type, this.numNotifs});

  Map<String, dynamic> toMap() {
    return {userIdCol: userId, typeCol: type, numNotifsCol: numNotifs};
  }

  Notif.fromMap(Map<String, dynamic> map)
      : this(
            userId: map[userIdCol],
            type: map[typeCol],
            numNotifs: map[numNotifsCol]);

  @override
  int get hashCode => userId.hashCode ^ typeCol.hashCode ^ numNotifs.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Notif &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          type == other.type &&
          numNotifs == other.numNotifs;

  @override
  String toString() {
    return 'Notif{userId: $userId, type: $type, numNotifs: $numNotifs}';
  }
}
