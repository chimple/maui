class Collection {
  static const table = 'collection';
  static const idCol = 'id';
  static const cardIdCol = 'cardId';
  static const serialCol = 'serial';

  String id;
  String cardId;
  int serial;

  static const allCols = [idCol, cardIdCol, serialCol];

  Collection({this.id, this.cardId, this.serial});

  Map<String, dynamic> toMap() {
    return {idCol: id, cardIdCol: cardId, serialCol: serial};
  }

  Collection.fromMap(Map<String, dynamic> map)
      : this(id: map[idCol], cardId: map[cardIdCol], serial: map[serialCol]);

  @override
  int get hashCode => id.hashCode ^ cardId.hashCode ^ serial.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Collection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cardId == other.cardId &&
          serial == other.serial;

  @override
  String toString() {
    return 'Collection{id: $id, cardId: $cardId, serial: $serial}';
  }
}
