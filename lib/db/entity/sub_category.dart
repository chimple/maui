class Subcategory {
  static const table = 'subcategory';
  static const categoryIdCol = 'categoryId';
  static const subcategoryIdCol = 'subcategoryId';
  static const serialCol = ' serial';

  String categoryId;
  String subcategoryId;
  int serial;

  Subcategory({this.categoryId, this.subcategoryId, this.serial});

  Map<String, dynamic> toMap() {
    return {
      categoryIdCol: categoryId,
      subcategoryIdCol: subcategoryId,
      serialCol: serial
    };
  }

  Subcategory.fromMap(Map<String, dynamic> map)
      : this(
            categoryId: map[categoryIdCol],
            subcategoryId: map[subcategoryIdCol],
            serial: map[serialCol]);

  @override
  // TODO: implement hashCode
  int get hashCode =>
      categoryId.hashCode ^ subcategoryId.hashCode ^ serial.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subcategory &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          subcategoryId == other.subcategoryId &&
          serial == other.serial;

  @override
  String toString() {
    return 'Category{categoryId: $categoryId, subcategoryId: $subcategoryId, serial: $serial}';
  }
}
