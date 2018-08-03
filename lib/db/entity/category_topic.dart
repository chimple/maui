class CategoryTopic {
  static const table = 'categoryTopic';
  static const categoryIdCol = 'categoryId';
  static const topicIdCol = 'topicId';
  static const serialCol = 'serial';

  String categoryId;
  String topicId;
  int serial;

  CategoryTopic({this.categoryId, this.topicId, this.serial});
  Map<String, dynamic> toMap() {
    return {categoryIdCol: categoryId, topicIdCol: topicId, serialCol: serial};
  }

  CategoryTopic.fromMap(Map<String, dynamic> map)
      : this(
            categoryId: map[categoryIdCol],
            topicId: map[topicIdCol],
            serial: map[serialCol]);

  @override
  int get hashCode => categoryId.hashCode ^ topicId.hashCode ^ serial.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTopic &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          topicId == other.topicId &&
          serial == other.serial;

  @override
  String toString() {
    return 'Topic{id: $categoryId, name: $topicId, serial: $serial}';
  }
}
