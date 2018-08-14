class MultipleChoice {
  static const table = 'multipleChoice';
  static const idCol = 'id';
  static const topicIdCol = 'topicId';
  static const questionCol = 'question';
  static const answerCol = 'answer';
  static const choice1Col = 'choice1';
  static const choice2Col = 'choice2';
  static const choice3Col = 'choice3';

  String id;
  String topicId;
  String question;
  String answer;
  String choice1;
  String choice2;
  String choice3;

  MultipleChoice(
      {this.id,
      this.topicId,
      this.question,
      this.answer,
      this.choice1,
      this.choice2,
      this.choice3});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      topicIdCol: topicId,
      questionCol: question,
      answerCol: answer,
      choice1Col: choice1,
      choice2Col: choice2,
      choice3Col: choice3,
    };
  }

  MultipleChoice.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            topicId: map[topicIdCol],
            question: map[questionCol],
            answer: map[answerCol],
            choice1: map[choice1Col],
            choice2: map[choice2Col],
            choice3: map[choice3Col]);

  @override
  int get hashCode =>
      id.hashCode ^
      topicId.hashCode ^
      question.hashCode ^
      answer.hashCode ^
      choice1.hashCode ^
      choice2.hashCode ^
      choice3.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultipleChoice &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          topicId == other.topicId &&
          question == other.question &&
          answer == other.answer &&
          choice1 == other.choice1 &&
          choice2 == other.choice2 &&
          choice3 == other.choice3;

  @override
  String toString() {
    return 'MultipleChoice{id: $id, topicId: $topicId, question: $question,  answer: $answer, choice1: $choice1, choice2: $choice2, choice3: $choice3}';
  }
}
