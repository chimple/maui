enum QuizType { oneAtATime, many, pair, open }

final quizTypeMap = {
  'oneAtATime': QuizType.oneAtATime,
  'many': QuizType.many,
  'pair': QuizType.pair,
  'open': QuizType.open
};

class Quiz {
  String id;
  QuizType type;
  String question;
  String questionAudio;
  String header;
  List<String> answers;
  List<String> answerAudios;
  List<String> choices;
  List<String> choiceAudios;
  Map<String, dynamic> quizInputs;

  Quiz(
      {this.id,
      this.type,
      this.question,
      this.questionAudio,
      this.header,
      this.answers,
      this.answerAudios,
      this.choices,
      this.choiceAudios,
      this.quizInputs});

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      question.hashCode ^
      questionAudio.hashCode ^
      header.hashCode ^
      answers.hashCode ^
      answerAudios.hashCode ^
      choices.hashCode ^
      choiceAudios.hashCode ^
      quizInputs.hashCode;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is Quiz &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          question == other.question &&
          questionAudio == other.questionAudio &&
          header == other.header &&
          answers == other.answers &&
          answerAudios == other.answerAudios &&
          choices == other.choices &&
          choiceAudios == other.choiceAudios &&
          quizInputs == other.quizInputs;

  @override
  String toString() {
    return 'Quiz{id: $id, type: $type, question: $question, questionAudio: $questionAudio, header: $header,answers: $answers,answerAudios: $answerAudios,choiceAudios: $choiceAudios, quizInputs: $quizInputs}';
  }
}
