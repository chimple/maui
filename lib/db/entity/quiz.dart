enum QuizType { oneAtATime, many, pair }

class Quiz {
  static const table = 'quiz';
  static const idCol = 'id';
  static const topicIdCol = 'topicId';
  static const levelCol = 'level';
  static const optionsTypeCol = 'optionsType';
  static const contentCol = 'content';

  String id;
  String topicId;
  int level;
  String optionsType;
  String content;

  Quiz({this.id, this.topicId, this.level, this.optionsType, this.content});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      topicIdCol: topicId,
      levelCol: level,
      optionsTypeCol: optionsType,
      contentCol: content
    };
  }

  Quiz.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            topicId: map[topicIdCol],
            level: map[levelCol],
            optionsType: map[optionsTypeCol],
            content: map[contentCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      topicId.hashCode ^
      level.hashCode ^
      optionsType.hashCode ^
      content.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quiz &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          topicId == other.topicId &&
          level == other.level &&
          optionsType == other.optionsType &&
          content == other.content;

  @override
  String toString() {
    return 'Quiz{id: $id, topicId: $topicId, level: $level, type: $optionsType, content: $content}';
  }

  QuizType get quizType {
    if (optionsType == 'oneAtATime') return QuizType.oneAtATime;
    if (optionsType == 'pair') return QuizType.pair;
    if (optionsType == 'many') return QuizType.many;
  }
}
