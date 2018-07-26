class Activity {
  static const table = 'activity';
  static const idCol = 'id';
  static const topicIdCol = 'topicId';
  static const orderCol = 'order';
  static const textCol = 'text';
  static const stickerPackCol = 'sticker_pack';

  String id;
  String topicId;
  int order;
  String text;
  String stickerPack;

  Activity({this.id, this.topicId, this.order, this.text, this.stickerPack});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      topicIdCol: topicId,
      orderCol: order,
      textCol: text,
      stickerPackCol: stickerPack
    };
  }

  Activity.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            topicId: map[topicIdCol],
            order: map[orderCol],
            text: map[textCol],
            stickerPack: map[stickerPackCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      topicId.hashCode ^
      order.hashCode ^
      text.hashCode ^
      stickerPack.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          topicId == other.topicId &&
          order == other.order &&
          text == other.text &&
          stickerPack == other.stickerPack;

  @override
  String toString() {
    return 'Topic{id: $id, topicId: $topicId, order: $order, stickerPack: $stickerPack}';
  }
}
