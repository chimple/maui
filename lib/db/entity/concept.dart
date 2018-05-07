class Concept {
  static const table = 'concept';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const areaIdCol = 'areaId';
  static const ddl = '''
CREATE TABLE $table (
  $idCol INTEGER PRIMARY KEY, 
  $nameCol TEXT)
''';

  int id;
  String name;
  int areaId;

  Concept({this.id, this.name, this.areaId});

  Map<String, dynamic> toMap() {
    return {idCol: id, nameCol: name, areaIdCol: areaId};
  }

  Concept.fromMap(Map<String, dynamic> map)
      : this(id: map[idCol], name: map[nameCol], areaId: map[areaIdCol]);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ areaId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Concept &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          areaId == other.areaId;

  @override
  String toString() {
    return 'Concept{id: $id, name: $name, areaId: $areaId}';
  }
}
