class Likes {
  static const table = 'likes';
  static const tileIdCol = 'tileId';
  static const likedUserIdCol = 'likedUserId';

  String tileId;
  String likedUserId;

  Likes({
    this.tileId,
    this.likedUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      tileIdCol: tileId,
      likedUserIdCol: likedUserId,
    };
  }

  Likes.fromMap(Map<String, dynamic> map)
      : this(
          tileId: map[tileIdCol],
          likedUserId: map[likedUserIdCol],
        );

  @override
  int get hashCode => tileId.hashCode ^ likedUserId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Likes &&
          runtimeType == other.runtimeType &&
          tileId == other.tileId &&
          likedUserId == other.likedUserId;

  @override
  String toString() {
    return 'Likes{tileId: $tileId, likedUserId: $likedUserId}';
  }
}
