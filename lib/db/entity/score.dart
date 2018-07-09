class Score {
  static const table = 'score';
  static const myUserCol = 'myUser';
  static const otherUserCol = 'otherUser';
  static const myScoreCol = 'myScore';
  static const otherScoreCol = 'otherScore';
  static const gameCol = 'game';
  static const playedAtCol = 'playedAt';

  String myUser;
  String otherUser;
  int myScore;
  int otherScore;
  String game;
  int playedAt;

  Score(
      {this.myUser,
      this.otherUser,
      this.myScore,
      this.otherScore,
      this.game,
      this.playedAt});

  Map<String, dynamic> toMap() {
    return {
      myUserCol: myUser,
      otherUserCol: otherUser,
      myScoreCol: myScore,
      otherScoreCol: otherScore,
      gameCol: game,
      playedAtCol: playedAt
    };
  }

  Score.fromMap(Map<String, dynamic> map, {String prefix = ''})
      : this(
            myUser: map[prefix + myUserCol],
            otherUser: map[prefix + otherUserCol],
            myScore: map[prefix + myScoreCol],
            otherScore: map[prefix + otherScoreCol],
            game: map[prefix + gameCol],
            playedAt: map[prefix + playedAtCol]);

  @override
  int get hashCode =>
      myUser.hashCode ^
      otherUser.hashCode ^
      myScore.hashCode ^
      otherScore.hashCode ^
      game.hashCode ^
      playedAt.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Score &&
          runtimeType == other.runtimeType &&
          myUser == other.myUser &&
          otherUser == other.otherUser &&
          myScore == other.myScore &&
          otherScore == other.otherScore &&
          game == other.game &&
          playedAt == other.playedAt;

  @override
  String toString() {
    return 'Score{myUser: $myUser, otherUser: $otherUser, myScore: $myScore, otherScore: $otherScore, game: $game, playedAt: $playedAt}';
  }
}
