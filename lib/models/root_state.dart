import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/collection.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/quack/user_activity.dart';

class RootState {
  final bool isLoading;
  final User user;
  final Map<String, QuackCard> frontMap;
  final Map<User, int> userMap;
  final Map<String, List<String>> collectionMap;
  final Map<String, QuackCard> cardMap;
  final Map<String, List<Comment>> commentMap;
  final Map<String, UserActivity> activityMap;
  final List<Tile> drawings;
  final List<CardExtra> templates;
  final List<Tile> tiles;

  RootState(
      {this.isLoading,
      this.frontMap,
      this.user,
      this.collectionMap,
      this.cardMap,
      this.activityMap,
      this.drawings,
      this.templates,
      this.tiles,
      this.userMap,
      this.commentMap});
}
