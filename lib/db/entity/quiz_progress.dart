class QuizProgress {
  static const table = 'quizProgress';
  static const idCol = 'id';
  static const userIdCol = 'userId';
  static const topicIdCol = 'topicId';
  static const quizIdCol = 'quizId';
  static const doneCol = 'done';

  String id;
  String userId;
  String topicId;
  String quizId;
  String done;

  QuizProgress({this.id, this.userId, this.topicId, this.quizId, this.done});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      userIdCol: userId, 
      topicIdCol: topicId, 
      quizIdCol: quizId, 
      doneCol: done};
  }

    QuizProgress.fromMap(Map<String, dynamic> map)
      : this(
        id: map[idCol], 
        userId: map[userIdCol],
        topicId: map[topicIdCol],
        quizId: map[quizIdCol],
        done: map[doneCol]);

    @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      topicId.hashCode ^
      quizId.hashCode ^
      done.hashCode;

       @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizProgress &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          topicId == other.topicId &&
          quizId == other.quizId &&
          done == other.done;

  @override
    String toString() {
      return 'Quiz{id: $id, userId: $userId, topicId: $topicId, quizId: $quizId, done: $done}';
    }


}