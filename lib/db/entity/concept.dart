class Concept {
  static const table = 'concept';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const ddl = '''
CREATE TABLE $table (
  $idCol INTEGER PRIMARY KEY, 
  $nameCol TEXT)
''';

  int id;
  String name;

  Concept({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {idCol: id, nameCol: name};
  }

  Concept.fromMap(Map<String, dynamic> map) : this (
      id: map[idCol],
      name: map[nameCol]
  );

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Concept &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  String toString() {
    return 'Concept{id: $id, name: $name}';
  }
}