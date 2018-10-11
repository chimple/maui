enum CardType { question, activity, concept, knowledge }

class QuackCard {
  static const table = 'card';

  static const idCol = 'id';
  static const typeCol = 'type';
  static const titleCol = 'title';
  static const titleAudioCol = 'titleAudio';
  static const headerCol = 'header';
  static const contentCol = 'content';
  static const contentAudioCol = 'contentAudio';
  static const optionCol = 'option';

  static const idSel = '${table}_id';
  static const typeSel = '${table}_type';
  static const titleSel = '${table}_title';
  static const titleAudioSel = '${table}_titleAudio';
  static const headerSel = '${table}_header';
  static const contentSel = '${table}_content';
  static const contentAudioSel = '${table}_contentAudio';
  static const optionSel = '${table}_option';

  String id;
  CardType type;
  String title;
  String titleAudio;
  String header;
  String content;
  String contentAudio;
  String option;

  static const allCols = [
    '${table}.$idCol AS $idSel',
    '${table}.$typeCol AS $typeSel',
    '${table}.$titleCol AS $titleSel',
    '${table}.$titleAudioCol AS $titleAudioSel',
    '${table}.$headerCol AS $headerSel',
    '${table}.$contentCol AS $contentSel',
    '${table}.$contentAudioCol AS $contentAudioSel',
    '${table}.$optionCol AS $optionSel'
  ];

  QuackCard(
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

  QuackCard.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idSel],
            type: CardType.values[map[typeSel]],
            title: map[titleSel],
            titleAudio: map[titleAudioSel],
            header: map[headerSel],
            content: map[contentSel],
            contentAudio: map[contentAudioSel],
            option: map[optionSel]);

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
      other is QuackCard &&
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
