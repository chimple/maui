enum CardExtraType { choice, answer, template }

class CardExtra {
  static const table = 'cardExtra';
  static const cardIdCol = 'cardId';
  static const typeCol = 'type';
  static const serialCol = 'serial';
  static const contentCol = 'content';
  static const contentAudioCol = 'contentAudio';

  String cardId;
  CardExtraType type;
  int serial;
  String content;
  String contentAudio;

  static const allCols = [
    cardIdCol,
    typeCol,
    serialCol,
    contentCol,
    contentAudioCol
  ];

  static const allPrefixedCols = [
    '$table.$cardIdCol',
    '$table.$typeCol',
    '$table.$serialCol',
    '$table.$contentCol',
    '$table.$contentAudioCol'
  ];

  CardExtra(
      {this.cardId, this.type, this.serial, this.content, this.contentAudio});

  Map<String, dynamic> toMap() {
    return {
      cardIdCol: cardId,
      typeCol: type.index,
      serialCol: serial,
      contentCol: content,
      contentAudioCol: contentAudio
    };
  }

  CardExtra.fromMap(Map<String, dynamic> map)
      : this(
            cardId: map[cardIdCol],
            type: CardExtraType.values[map[typeCol]],
            serial: map[serialCol],
            content: map[contentCol],
            contentAudio: map[contentAudioCol]);

  @override
  int get hashCode =>
      cardId.hashCode ^
      type.hashCode ^
      serial.hashCode ^
      content.hashCode ^
      contentAudio.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardExtra &&
          runtimeType == other.runtimeType &&
          cardId == other.cardId &&
          type == other.type &&
          serial == other.serial &&
          content == other.content &&
          contentAudio == other.contentAudio;

  @override
  String toString() {
    return 'Card{cardId: $cardId, type: $type, serial: $serial, content: $content,contentAudio: $contentAudio}';
  }
}
