class Topic {
  static const table = 'topic';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const imageCol = 'image';
  static const colorCol = 'color';

  String id;
  String name;
  String image;
  int color;

  Topic({this.id, this.name, this.image, this.color});

  Map<String, dynamic> toMap() {
    return {idCol: id, nameCol: name, imageCol: image, colorCol: color};
  }

  Topic.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            name: map[nameCol],
            image: map[imageCol],
            color: map[colorCol]);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ image.hashCode ^ color.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Topic &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color &&
          image == other.image;

  @override
  String toString() {
    return 'Topic{id: $id, name: $name, image: $image, color: $color}';
  }
}
