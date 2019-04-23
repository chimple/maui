import 'package:json_annotation/json_annotation.dart';

part 'quiz.g.dart';

enum QuizType { oneAtATime, many, pair, open }

final quizTypeMap = {
  'oneAtATime': QuizType.oneAtATime,
  'many': QuizType.many,
  'pair': QuizType.pair,
  'open': QuizType.open
};

@JsonSerializable(nullable: false)
class Quiz {
  String id;
  QuizType type;
  String question;
  String questionAudio;
  String header;
  @JsonKey(nullable: true)
  List<String> answers;
  @JsonKey(nullable: true)
  List<String> answerAudios;
  @JsonKey(nullable: true)
  List<String> choices;
  @JsonKey(nullable: true)
  List<String> choiceAudios;

  Quiz(
      {this.id,
      this.type,
      this.question,
      this.questionAudio,
      this.header,
      this.answers,
      this.answerAudios,
      this.choices,
      this.choiceAudios});

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
      choiceAudios.hashCode;

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
          choiceAudios == other.choiceAudios;

  @override
  String toString() {
    return 'Quiz{id: $id, type: $type, question: $question, questionAudio: $questionAudio, header: $header,answers: $answers,answerAudios: $answerAudios,choices: $choices, choiceAudios: $choiceAudios}';
  }

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}
