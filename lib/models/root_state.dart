import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/collection.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';

class RootState {
  final bool isLoading;
  final User user;
  final Map<String, List<String>> collectionMap;
  final Map<String, QuackCard> cardMap;
  final Map<String, double> progressMap;
  final Map<String, List<Comment>> commentMap;
  final Map<String, Like> likeMap;
  final List<Tile> tiles;
  final List<CardExtra> templates;

  RootState(
      {this.isLoading,
      this.user,
      this.collectionMap,
      this.cardMap,
      this.progressMap,
      this.likeMap,
      this.tiles,
      this.templates,
      this.commentMap});
}
