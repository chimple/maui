class TrueOrFalse {
  static const table = 'trueOrFalse';
  static const idCol = 'id';
  static const topicIdCol = 'topicId';
  static const questionCol = 'question';
  static const associatedQuestionCol = 'associatedQuestion';
  static const isTrueCol = 'isTrue';

  String id, topicId, question, associatedQuestion, isTrue;

  TrueOrFalse({ this.id, this.topicId, this.question, this.associatedQuestion, this.isTrue});

  Map<String, dynamic> toMap() {
    return {idCol: id, topicIdCol: topicId, questionCol: question, associatedQuestionCol: associatedQuestion, isTrueCol: isTrue};
  }

  TrueOrFalse.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            topicId: map[topicIdCol],
            question: map[questionCol],
            associatedQuestion: map[associatedQuestionCol],
            isTrue: map[isTrueCol]);

  @override
  int get hashCode =>
      id.hashCode ^ topicId.hashCode ^ question.hashCode ^ associatedQuestion.hashCode ^ isTrue.hashCode;

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
      other is TrueOrFalse &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          topicId == other.topicId &&
          question == other.question &&
          associatedQuestion == other.associatedQuestion &&
          isTrue == other.isTrue;

  @override
  String toString() {
    return 'Topic{id: $id, topicId: $topicId, question: $question, associatedQuestion: $associatedQuestion, isTrue: $isTrue}';
  }
}
