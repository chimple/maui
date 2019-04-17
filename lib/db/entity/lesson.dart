enum TopicType { reading, math }

enum ConceptType {
  dummy,
  upperCaseLetter,
  upperCaseToLowerCase,
  lowerCaseLetterToWord,
  syllableToWord,
  upperCaseLetterToWord,
  lowerCaseLetter,
  singleDigitAdditionWithoutCarryover,
  singleDigitAdditionWithCarryover,
  doubleDigitAdditionWithoutCarryover,
  doubleDigitAdditionWithCarryover,
  tripleDigitAdditionWithoutCarryover,
  tripleDigitAdditionWithCarryover,
  singleDigitSubtractionWithoutBorrow,
  singleDigitSubtractionWithBorrow,
  doubleDigitSubtractionWithoutBorrow,
  doubleDigitSubtractionWithBorrow,
  tripleDigitSubtractionWithoutBorrow,
  tripleDigitSubtractionWithBorrow,
  singleDigitMultiplication,
  singleDigitWithDoubleDigitMultiplication,
  doubleDigitMultiplication,
  tables1,
  tables2,
  tables3,
  tables4,
  tables5,
  tables6,
  tables7,
  tables8,
  tables9,
  tables10,
  number1,
  number2,
  number3,
  number4,
  number5,
  number6,
  number7,
  number8,
  number9,
  number10,
  numbers0to9,
  numbers0to99,
}

class Lesson {
  static const table = 'lesson';
  static const idCol = 'id';
  static const titleCol = 'title';
  static const conceptIdCol = 'conceptId';
  static const seqCol = 'seq';
  static const hasOrderCol = 'hasOrder';
  static const topicCol = 'topic';
  static const imageCol = 'image';

  int id;
  String title;
  ConceptType conceptId;
  int seq;
  int hasOrder;
  TopicType topic;
  String image;

  static const maxLessonId = 90;

  static const List<String> allCols = [
    Lesson.idCol,
    Lesson.titleCol,
    Lesson.conceptIdCol,
    Lesson.seqCol,
    Lesson.hasOrderCol,
    Lesson.topicCol,
    Lesson.imageCol,
  ];

  Lesson({
    this.id,
    this.title,
    this.conceptId,
    this.seq,
    this.hasOrder,
    this.topic,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      titleCol: title,
      conceptIdCol: conceptId.index,
      seqCol: seq,
      hasOrderCol: hasOrder,
      topicCol: topic.index,
      imageCol: image,
    };
  }

  Lesson.fromMap(Map<String, dynamic> map)
      : this(
          id: map[idCol],
          title: map[titleCol],
          conceptId: ConceptType.values[map[conceptIdCol]],
          seq: map[seqCol],
          hasOrder: map[hasOrderCol],
          topic: TopicType.values[map[topicCol]],
          image: map[imageCol],
        );

  @override
  int get hashCode =>
      id.hashCode ^
      titleCol.hashCode ^
      conceptId.hashCode ^
      seq.hashCode ^
      hasOrder.hashCode ^
      topic.hashCode ^
      image.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lesson &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          conceptId == other.conceptId &&
          seq == other.seq &&
          hasOrder == other.hasOrder &&
          topic == other.topic &&
          image == other.image;

  @override
  String toString() {
    return 'Lesson{id: $id, title: $title, conceptId: $conceptId, seq: $seq, hasOrder: $hasOrder, topic: $topic, image: $image}';
  }
}
