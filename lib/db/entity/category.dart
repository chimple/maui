class Category{
  static const table = 'category';
  static const categoryIdCol = 'categoryId';
  static const nameCol = 'name';
  static const colorCol = 'color';
  static const imageCol = 'image';

  String categoryId;
  String name;
  int color;
  String image;

  Category({this.categoryId, this.name, this.color, this.image});

  Map<String, dynamic> toMap(){
    return{categoryIdCol: categoryId, nameCol: name, colorCol: color, imageCol: image};
  }

  Category.fromMap(Map<String, dynamic>map): this(
    categoryId: map[categoryIdCol],
    name: map[nameCol],
    color: map[colorCol],
    image: map[imageCol]
  );

  @override
    // TODO: implement hashCode
    int get hashCode => categoryId.hashCode ^ name.hashCode ^ color.hashCode ^ image.hashCode;

 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          name == other.name &&
          image == other.image &&
          color == other.color;

  @override
  String toString() {
    return 'Category{categoryId: $categoryId, name: $name, color: $color, image: $image}';
  }
}