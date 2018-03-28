class Concept {
  static const table = 'concept';
  static const columnId = 'id';
  static const columnName = 'name';
  static const ddl = '''
CREATE TABLE $table (
  $columnId INTEGER PRIMARY KEY, 
  $columnName TEXT)
''';

  String id;
  String name;

  Concept({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {columnId: id, columnName: name};
  }

  Concept.fromMap(Map<String, dynamic> map) : this (
      id: map[columnId],
      name: map[columnName]
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