class CategoryTopic {
  static const table = 'categoryTopic';
  static const categoryIdCol = 'categoryId';
  static const topicIdCol = 'topicId';
  static const orderCol = 'order';

  String categoryId;
  String topicId;
  int order;

  CategoryTopic({this.categoryId, this.topicId, this.order});
  Map<String, dynamic> toMap() {
    return {categoryIdCol: categoryId, topicIdCol: topicId, orderCol: order};
  }

  CategoryTopic.fromMap(Map<String, dynamic> map)
      : this(
            categoryId: map[categoryIdCol],
            topicId: map[topicIdCol],
            order: map[orderCol]);

  @override
  int get hashCode => categoryId.hashCode ^ topicId.hashCode ^ order.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTopic &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          topicId == other.topicId &&
          order == other.order;

  @override
  String toString() {
    return 'Topic{id: $categoryId, name: $topicId, order: $order}';
  }
}
