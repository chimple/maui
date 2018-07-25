class SubCategory{
  static const table = 'subcategory';
  static const category_idCol = 'category_id';
  static const sub_category_idCol = 'sub_category_id';
  static const orderCol = ' order';

  String category_id;
  String sub_category_id;
  int order;

  SubCategory({this.category_id, this.sub_category_id, this.order});

  Map<String, dynamic> toMap(){
    return{category_idCol: category_id, sub_category_idCol: sub_category_id, orderCol: order};
  }

  SubCategory.fromMap(Map<String, dynamic>map): this(
    category_id: map[category_idCol],
    sub_category_id: map[sub_category_idCol],
    order: map[orderCol]
  );

  @override
    // TODO: implement hashCode
    int get hashCode => category_id.hashCode ^ sub_category_id.hashCode ^ order.hashCode;

 @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategory &&
          runtimeType == other.runtimeType &&
          category_id == other.category_id &&
          sub_category_id == other.sub_category_id &&
          order == other.order;

  @override
  String toString() {
    return 'Category{category_id: $category_id, sub_category_id: $sub_category_id, order: $order}';
  }
}