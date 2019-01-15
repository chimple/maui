import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:meta/meta.dart';

@immutable
class RedState {
  final Map<String, bool> isLoading;
  final Map<String, List<Comment>> comments;
  final List<Tile> tiles;
  final Map<String, List<QuackCard>> cards;
  final Map<String, UserActivity> activityMap;
  final List<Tile> drawings;
  final User user;

  RedState(
      {this.isLoading = const {
        'comments': false,
        'tiles': false,
        'cards': false
      },
      this.user,
      this.activityMap,
      this.cards,
      this.tiles,
      this.drawings,
      this.comments});

  factory RedState.loading() => RedState(
      isLoading: {'comments': true, 'tiles': true, 'cards': true},
      cards: {},
      comments: {},
      activityMap: {},
      drawings: []);

  @override
  int get hashCode =>
      isLoading.hashCode ^
      comments.hashCode ^
      tiles.hashCode ^
      cards.hashCode ^
      user.hashCode ^
      drawings.hashCode ^
      activityMap.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RedState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          comments == other.comments &&
          cards == other.cards &&
          user == other.user &&
          activityMap == other.activityMap &&
          drawings == other.drawings &&
          tiles == other.tiles;

  @override
  String toString() {
    return 'RedState{isLoading: $isLoading, comments: $comments, cards: $cards, tiles: $tiles, activityMap: $activityMap, drawings: $drawings, user: $user}';
  }
}
