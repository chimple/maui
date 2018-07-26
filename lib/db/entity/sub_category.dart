class Subcategory {
  static const table = 'subcategory';
  static const categoryIdCol = 'categoryId';
  static const subcategoryIdCol = 'subcategoryId';
  static const orderCol = ' order';

  String categoryId;
  String subcategoryId;
  int order;

  Subcategory({this.categoryId, this.subcategoryId, this.order});

  Map<String, dynamic> toMap() {
    return {categoryIdCol: categoryId, subcategoryIdCol: subcategoryId, orderCol: order};
  }

  Subcategory.fromMap(Map<String, dynamic> map)
      : this(
            categoryId: map[categoryIdCol],
            subcategoryId: map[subcategoryIdCol],
            order: map[orderCol]);

  @override
  // TODO: implement hashCode
  int get hashCode => categoryId.hashCode ^ subcategoryId.hashCode ^ order.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subcategory &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          subcategoryId == other.subcategoryId &&
          order == other.order;

  @override
  String toString() {
    return 'Category{categoryId: $categoryId, subcategoryId: $subcategoryId, order: $order}';
  }
}
