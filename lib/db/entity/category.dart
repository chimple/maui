class Category{
  static const table = 'category';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const colorCol = 'color';

  String id;
  String name;
  int color;

  Category({this.id, this.name, this.color});

  Map<String, dynamic> toMap(){
    return{idCol: id, nameCol: name, colorCol: color};
  }

  Category.fromMap(Map<String, dynamic>map): this(
    id: map[idCol],
    name: map[nameCol],
    color: map[colorCol]
  );

  @override
    // TODO: implement hashCode
    int get hashCode => id.hashCode ^ name.hashCode ^ color.hashCode;

 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color;

  @override
  String toString() {
    return 'Category{id: $id, name: $name, color: $color}';
  }
}