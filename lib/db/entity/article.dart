class Article {
  static const table = 'article';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const topicIdCol = 'topicId';
  static const orderCol = 'order';
  static const videoCol = 'video';
  static const audioCol = 'audio';
  static const imageCol = 'image';
  static const textCol = 'text';

  String id;
  String name;
  String topicId;
  int order;
  String video;
  String audio;
  String image;
  String text;

  Article(
      {this.id,
      this.name,
      this.topicId,
      this.order,
      this.video,
      this.audio,
      this.image,
      this.text});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      nameCol: name,
      topicIdCol: topicId,
      orderCol: order,
      videoCol: video,
      audioCol: audio,
      imageCol: image,
      textCol: text
    };
  }

  Article.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            name: map[nameCol],
            topicId: map[topicIdCol],
            order: map[orderCol],
            video: map[videoCol],
            audio: map[audioCol],
            image: map[imageCol],
            text: map[textCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      topicId.hashCode ^
      order.hashCode ^
      video.hashCode ^
      audio.hashCode ^
      image.hashCode ^
      text.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          topicId == other.topicId &&
          order == other.order &&
          video == other.video &&
          audio == other.audio &&
          image == other.image &&
          text == other.text;

  @override
  String toString() {
    return 'Article{id: $id, name: $name, topicId: $topicId,order: $order,video: $video,audio: $audio,image: $image, text: $text}';
  }
}
