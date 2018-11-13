import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/user.dart';

enum TileType { drawing, card, message, dot }

class Tile {
  static const table = 'tile';

  static const idCol = 'id';
  static const cardIdCol = 'cardId';
  static const contentCol = 'content';
  static const typeCol = 'type';
  static const likesCol = 'likes';
  static const commentsCol = 'comments';
  static const userIdCol = 'userId';
  static const updatedAtCol = 'updatedAt';

  static const idSel = '${table}_id';
  static const cardIdSel = '${table}_cardId';
  static const contentSel = '${table}_content';
  static const typeSel = '${table}_type';
  static const likesSel = '${table}_likes';
  static const commentsSel = '${table}_comments';
  static const userIdSel = '${table}_userId';
  static const updatedAtSel = '${table}_updatedAt';

  static const allCols = [
    '${table}.$idCol AS $idSel',
    '${table}.$cardIdCol AS $cardIdSel',
    '${table}.$contentCol AS $contentSel',
    '${table}.$typeCol AS $typeSel',
    '${table}.$userIdCol AS $userIdSel',
    '${table}.$likesCol AS $likesSel',
    '${table}.$commentsCol AS $commentsSel',
    '${table}.$updatedAtCol AS $updatedAtSel',
    '${QuackCard.table}.${QuackCard.idCol} AS ${QuackCard.idSel}',
    '${QuackCard.table}.${QuackCard.typeCol} AS ${QuackCard.typeSel}',
    '${QuackCard.table}.${QuackCard.titleCol} AS ${QuackCard.titleSel}',
    '${QuackCard.table}.${QuackCard.titleAudioCol} AS ${QuackCard.titleAudioSel}',
    '${QuackCard.table}.${QuackCard.headerCol} AS ${QuackCard.headerSel}',
    '${QuackCard.table}.${QuackCard.contentCol} AS ${QuackCard.contentSel}',
    '${QuackCard.table}.${QuackCard.contentAudioCol} AS ${QuackCard.contentAudioSel}',
    '${QuackCard.table}.${QuackCard.optionCol} AS ${QuackCard.optionSel}',
    '${QuackCard.table}.${QuackCard.commentsCol} AS ${QuackCard.commentsSel}',
    '${QuackCard.table}.${QuackCard.likesCol} AS ${QuackCard.likesSel}',
    '${User.table}.${User.idCol} AS ${User.idSel}',
    '${User.table}.${User.deviceIdCol} AS ${User.deviceIdSel}',
    '${User.table}.${User.nameCol} AS ${User.nameSel}',
    '${User.table}.${User.colorCol} AS ${User.colorSel}',
    '${User.table}.${User.imageCol} AS ${User.imageSel}',
    '${User.table}.${User.pointsCol} AS ${User.pointsSel}',
    '${User.table}.${User.currentLessonIdCol} AS ${User.currentLessonIdSel}',
  ];

  String id;
  String cardId;
  String content;
  TileType type;
  String userId;
  int likes;
  int comments;
  DateTime updatedAt;
  QuackCard card;
  User user;

  Tile(
      {this.id,
      this.cardId,
      this.content,
      this.type,
      this.likes,
      this.comments,
      this.userId,
      this.updatedAt,
      this.card,
      this.user});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      cardIdCol: cardId,
      contentCol: content,
      typeCol: type.index,
      userIdCol: userId,
      likesCol: likes,
      commentsCol: comments,
      updatedAtCol: updatedAt == null ? null : updatedAt.millisecondsSinceEpoch
    };
  }

  Tile.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idSel],
            cardId: map[cardIdSel],
            content: map[contentSel],
            type: TileType.values[map[typeSel]],
            userId: map[userIdSel],
            likes: map[likesSel],
            comments: map[commentsSel],
            updatedAt: map[updatedAtSel] == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(map[updatedAtSel]),
            card: QuackCard.fromMap(map),
            user: User.fromMap(map));

  @override
  int get hashCode =>
      id.hashCode ^
      cardId.hashCode ^
      content.hashCode ^
      type.hashCode ^
      userId.hashCode ^
      likes.hashCode ^
      comments.hashCode ^
      updatedAt.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cardId == other.cardId &&
          content == other.content &&
          type == other.type &&
          userId == other.userId &&
          likes == other.likes &&
          comments == other.comments &&
          updatedAt == other.updatedAt;

  @override
  String toString() {
    return '''Tile{id: $id, cardId: $cardId, type: $type, userId: $userId, likes: $likes, comments: $comments, updatedAt: $updatedAt}
content: $content
card: $card
user: $user'
''';
  }
}
