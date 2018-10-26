class Collection {
  static const table = 'collection';

  static const idCol = '${table}.id';
  static const cardIdCol = '${table}.cardId';
  static const serialCol = '${table}.serial';

  static const idSel = '${table}_id';
  static const cardIdSel = '${table}_cardId';
  static const serialSel = '${table}_serial';

  String id;
  String cardId;
  int serial;

  static const allCols = [
    '$idCol AS $idSel',
    '$cardIdCol AS $cardIdSel',
    '$serialCol AS $serialSel'
  ];

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
