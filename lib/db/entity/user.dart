import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';

class User {
  static const table = 'user';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnImage = 'image';
  static const ddl = '''
CREATE TABLE $table (
  $columnId TEXT PRIMARY KEY, 
  $columnName TEXT, 
  $columnImage TEXT)
''';

  String id;
  String name;
  String image;

  User({String id, this.name, this.image})
    : this.id = id ?? new Uuid().v4();

  Map<String, dynamic> toMap() {
    return {columnId: id, columnName: name, columnImage: image};
  }

  User.fromMap(Map<String, dynamic> map) : this (
    id: map[columnId],
    name: map[columnName],
    image: map[columnImage]
  );

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ image.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              image == other.image;

  @override
  String toString() {
    return 'User{id: $id, name: $name, image: $image}';
  }
}