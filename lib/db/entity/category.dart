class Category {
  static const table = 'category';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const colorCol = 'color';
  static const imageCol = 'image';

  String id;
  String name;
  int color;
  String image;

  Category({this.id, this.name, this.color, this.image});

  Map<String, dynamic> toMap() {
    return {idCol: id, nameCol: name, colorCol: color, imageCol: image};
  }

  Category.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            name: map[nameCol],
            color: map[colorCol],
            image: map[imageCol]);

  @override
  // TODO: implement hashCode
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ color.hashCode ^ image.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          image == other.image &&
          color == other.color;

  @override
  String toString() {
    return 'Category{id: $id, name: $name, color: $color, image: $image}';
  }
}
