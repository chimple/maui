class GameCategory {
  static const table = 'gameCategory';
  static const idCol = 'id';
  static const seqCol = 'seq';
  static const gameCol = 'game';
  static const conceptIdCol = 'conceptId';
  static const lessonIdCol = 'lessonId';
  static const nameCol = 'name';

  int id;
  int seq;
  String game;
  int conceptId;
  int lessonId;
  String name;

  GameCategory(
      {this.id, this.seq, this.game, this.conceptId, this.lessonId, this.name});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      seqCol: seq,
      gameCol: game,
      conceptIdCol: conceptId,
      lessonIdCol: lessonId,
      nameCol: name
    };
  }

  GameCategory.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            seq: map[seqCol],
            game: map[gameCol],
            conceptId: map[conceptIdCol],
            lessonId: map[lessonIdCol],
            name: map[nameCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      seq.hashCode ^
      game.hashCode ^
      conceptId.hashCode ^
      lessonId.hashCode ^
      name.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          seq == other.seq &&
          game == other.game &&
          conceptId == other.conceptId &&
          lessonId == other.lessonId &&
          name == other.name;

  @override
  String toString() {
    return 'GameCategory{id: $id, seq: $seq, game: $game, conceptId: $conceptId, lessonId: $lessonId, name: $name}';
  }
}
