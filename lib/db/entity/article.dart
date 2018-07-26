class Article {
  static const table = 'article';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const topicIdCol = 'topicId';
  static const videoCol = 'video';
  static const audioCol = 'audio';
  static const imageCol = 'image';
  static const textCol = 'text';
  static const orderCol = 'order';

  String id;
  String name;
  String topicId;
    String video;
  String audio;
  String image;
  String text;
  int order;

  Article(
      {this.id,
      this.name,
      this.topicId,
      this.video,
      this.audio,
      this.image,
      this.text,
      this.order});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      nameCol: name,
      topicIdCol: topicId,
            videoCol: video,
      audioCol: audio,
      imageCol: image,
      textCol: text,
      orderCol: order
    };
  }

  Article.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            name: map[nameCol],
            topicId: map[topicIdCol],
                        video: map[videoCol],
            audio: map[audioCol],
            image: map[imageCol],
            text: map[textCol],
            order: map[orderCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      topicId.hashCode ^
            video.hashCode ^
      audio.hashCode ^
      image.hashCode ^
      text.hashCode ^
      order.hashCode ;


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
