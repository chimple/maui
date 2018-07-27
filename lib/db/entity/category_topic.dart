class CategoryTopic {
  static const table = 'categoryTopic';
  static const idcCol = 'categoryId';
  static const idtCol = 'topicId';
  static const orderCol = 'order';
  String categoryId;
  String topicId;

  int order;

  CategoryTopic({this.categoryId, this.topicId, this.order});

  Map<String, dynamic> toMap() {
    return {idcCol: categoryId, idtCol: topicId, orderCol: order};
  }

  CategoryTopic.fromMap(Map<String, dynamic> map)
      : this(
            categoryId: map[idcCol],
            topicId: map[idtCol],
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
    return 'Topic{id: $categoryId, name: $topicId, color: $order}';
  }
}
