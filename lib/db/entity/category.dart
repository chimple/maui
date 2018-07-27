class Category{
  static const table = 'category';
  static const categoryIdCol = 'id';
  static const nameCol = 'name';
  static const colorCol = 'color';

  String id;
  String name;
  int color;

  Category({this.id, this.name, this.color});

  Map<String, dynamic> toMap(){
    return{categoryIdCol: id, nameCol: name, colorCol: color};
  }

  Category.fromMap(Map<String, dynamic>map): this(
    id: map[categoryIdCol],
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
    return 'Category{categoryId: $categoryIdCol, name: $name, color: $color}';
  }
}