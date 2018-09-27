enum QuizType {
  unknown,
  multipleChoice,
  trueOrFalse,
  matchTheFollowing,
  grouping,
  sequence
}

class Quiz {
  static const table = 'quiz';
  static const idCol = 'id';
  static const topicIdCol = 'topicId';
  static const levelCol = 'level';
  static const typeCol = 'type';
  static const contentCol = 'content';

  String id;
  String topicId;
  int level;
  String type;
  String content;

  Quiz({this.id, this.topicId, this.level, this.type, this.content});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      topicIdCol: topicId,
      levelCol: level,
      typeCol: type,
      contentCol: content
    };
  }

  Quiz.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            topicId: map[topicIdCol],
            level: map[levelCol],
            type: map[typeCol],
            content: map[contentCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      topicId.hashCode ^
      level.hashCode ^
      type.hashCode ^
      content.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quiz &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          topicId == other.topicId &&
          level == other.level &&
          type == other.type &&
          content == other.content;

  @override
  String toString() {
    return 'Quiz{id: $id, topicId: $topicId, level: $level, type: $type, content: $content}';
  }

  QuizType get quizType {
    if (type == 'multipleChoice') return QuizType.multipleChoice;
    if (type == 'trueOrFalse') return QuizType.trueOrFalse;
    if (type == 'matchTheFollowing') return QuizType.matchTheFollowing;
    if (type == 'grouping') return QuizType.grouping;
    if (type == 'sequence') return QuizType.sequence;
    return QuizType.unknown;
  }
}
