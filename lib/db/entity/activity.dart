class Activity {
  static const table = 'activity';
  static const idCol = 'id';
  static const topicIdCol = 'topicId';
  static const textCol = 'text';
  static const stickerPackCol = 'stickerPack';
  static const serialCol = 'serial';
  static const imageCol = 'image';
  static const audioCol = 'audio';
  static const videoCol = 'video';

  String id;
  String topicId;
  String text;
  String stickerPack;
  int serial;
  String image;
  String audio;
  String video;

  Activity(
      {this.id,
      this.topicId,
      this.serial,
      this.text,
      this.stickerPack,
      this.image,
      this.audio,
      this.video});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      topicIdCol: topicId,
      serialCol: serial,
      textCol: text,
      stickerPackCol: stickerPack,
      imageCol: image,
      audioCol: audio,
      videoCol: video
    };
  }

  Activity.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            topicId: map[topicIdCol],
            serial: map[serialCol],
            text: map[textCol],
            stickerPack: map[stickerPackCol],
            image: map[imageCol],
            audio: map[audioCol],
            video: map[videoCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      topicId.hashCode ^
      serial.hashCode ^
      text.hashCode ^
      stickerPack.hashCode ^
      image.hashCode ^
      audio.hashCode ^
      video.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          topicId == other.topicId &&
          serial == other.serial &&
          text == other.text &&
          stickerPack == other.stickerPack &&
          image == other.image &&
          audio == other.audio &&
          video == other.video;

  @override
  String toString() {
    return 'Activity{id: $id, topicId: $topicId, serial: $serial,'
        ' stickerPack: $stickerPack,image:$image,audio:$audio,video:$video}';
  }
}
