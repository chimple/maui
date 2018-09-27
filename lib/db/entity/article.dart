class Article {
  static const table = 'article';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const topicIdCol = 'topicId';
  static const serialCol = 'serial';
  static const videoCol = 'video';
  static const audioCol = 'audio';
  static const imageCol = 'image';
  static const textCol = 'text';

  String id;
  String name;
  String topicId;
  int serial;
  String video;
  String audio;
  String image;
  String text;

  Article(
      {this.id,
      this.name,
      this.topicId,
      this.serial,
      this.video,
      this.audio,
      this.image,
      this.text});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      nameCol: name,
      topicIdCol: topicId,
      serialCol: serial,
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
            serial: map[serialCol],
            video: map[videoCol],
            audio: map[audioCol],
            image: map[imageCol],
            text: map[textCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      topicId.hashCode ^
      serial.hashCode ^
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
          serial == other.serial &&
          video == other.video &&
          audio == other.audio &&
          image == other.image &&
          text == other.text;

  @override
  String toString() {
    return 'Article{id: $id, name: $name, topicId: $topicId,serial: $serial,video: $video,audio: $audio,image: $image, text: $text}';
  }
}
