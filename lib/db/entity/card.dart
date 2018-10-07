enum CardType { question, activity, collection, knowledge }

class Card {
  static const table = 'card';
  static const idCol = 'id';
  static const typeCol = 'type';
  static const titleCol = 'title';
  static const titleAudioCol = 'titleAudio';
  static const headerCol = 'header';
  static const contentCol = 'content';
  static const contentAudioCol = 'contentAudio';
  static const optionCol = 'option';

  String id;
  CardType type;
  String title;
  String titleAudio;
  String header;
  String content;
  String contentAudio;
  String option;

  static const allCols = [
    idCol,
    typeCol,
    titleCol,
    titleAudioCol,
    headerCol,
    contentCol,
    contentAudioCol,
    optionCol
  ];

  static const allPrefixedCols = [
    '$table.$idCol',
    '$table.$typeCol',
    '$table.$titleCol',
    '$table.$titleAudioCol',
    '$table.$headerCol',
    '$table.$contentCol',
    '$table.$contentAudioCol',
    '$table.$optionCol'
  ];

  Card(
      {this.id,
      this.type,
      this.title,
      this.titleAudio,
      this.header,
      this.content,
      this.contentAudio,
      this.option});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      typeCol: type.index,
      titleCol: title,
      titleAudioCol: titleAudio,
      headerCol: header,
      contentCol: content,
      contentAudioCol: contentAudio,
      optionCol: option
    };
  }

  Card.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            type: CardType.values[map[typeCol]],
            title: map[titleCol],
            titleAudio: map[titleAudioCol],
            header: map[headerCol],
            content: map[contentCol],
            contentAudio: map[contentAudioCol],
            option: map[optionCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      title.hashCode ^
      titleAudio.hashCode ^
      header.hashCode ^
      content.hashCode ^
      contentAudio.hashCode ^
      option.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Card &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          titleAudio == other.titleAudio &&
          header == other.header &&
          content == other.content &&
          contentAudio == other.contentAudio &&
          option == other.option;

  @override
  String toString() {
    return 'Card{id: $id, title: $title, titleAudio: $titleAudio, header: $header,content: $content,contentAudio: $contentAudio,option: $option}';
  }
}
