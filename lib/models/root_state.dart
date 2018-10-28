import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/collection.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/user.dart';

class RootState {
  final bool isLoading;
  final User user;
  final Map<String, List<String>> collectionMap;
  final Map<String, QuackCard> cardMap;
  final Map<String, double> progressMap;
  final List<Comment> comments;
  final Map<String, Like> likeMap;

  RootState(
      {this.isLoading,
      this.user,
      this.collectionMap,
      this.cardMap,
      this.progressMap,
      this.likeMap,
      this.comments}) {
    print('RootState: comments: $comments');
  }
}
