import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_comment.dart';
import 'package:maui/actions/add_like.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/like_repo.dart';

class CollectionMiddleware extends Middleware<RootState> {
  final CollectionRepo collectionRepo;
  final CardProgressRepo cardProgressRepo;
  final LikeRepo likeRepo;
  final CommentRepo commentRepo;
  final CardRepo cardRepo;

  CollectionMiddleware(
      {this.collectionRepo,
      this.cardProgressRepo,
      this.likeRepo,
      this.commentRepo,
      this.cardRepo});

  @override
  RootState beforeAction(ActionType action, RootState state) {
    if (action is FetchInitialData) {
      action.collectionRepo = collectionRepo;
      action.cardProgressRepo = cardProgressRepo;
      action.likeRepo = likeRepo;
    } else if (action is FetchCardDetail) {
      action.collectionRepo = collectionRepo;
      action.cardProgressRepo = cardProgressRepo;
      action.likeRepo = likeRepo;
      action.commentRepo = commentRepo;
      action.cardRepo = cardRepo;
    } else if (action is AddProgress) {
      action.cardProgressRepo = cardProgressRepo;
    } else if (action is AddLike) {
      action.likeRepo = likeRepo;
    } else if (action is AddComment) {
      action.commentRepo = commentRepo;
    }

    return state;
  }

  @override
  RootState afterAction(ActionType action, RootState state) {
    return state;
  }
}
