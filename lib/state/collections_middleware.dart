import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_comment.dart';
import 'package:maui/actions/add_like.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/update_points.dart';
import 'package:maui/actions/fetch_comments.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/actions/fetch_tile_detail.dart';
import 'package:maui/actions/post_tile.dart';
import 'package:maui/actions/save_drawing.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_extra_repo.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/repos/user_repo.dart';

class CollectionMiddleware extends Middleware<RootState> {
  final CollectionRepo collectionRepo;
  final CardProgressRepo cardProgressRepo;
  final LikeRepo likeRepo;
  final CommentRepo commentRepo;
  final CardRepo cardRepo;
  final TileRepo tileRepo;
  final CardExtraRepo cardExtraRepo;
  final UserRepo userRepo;

  CollectionMiddleware(
      {this.collectionRepo,
      this.cardProgressRepo,
      this.likeRepo,
      this.commentRepo,
      this.tileRepo,
      this.cardExtraRepo,
      this.userRepo,
      this.cardRepo});

  @override
  RootState beforeAction(ActionType action, RootState state) {
    if (action is FetchInitialData) {
      action.collectionRepo = collectionRepo;
      action.cardProgressRepo = cardProgressRepo;
      action.likeRepo = likeRepo;
      action.tileRepo = tileRepo;
      action.userRepo = userRepo;
      action.cardRepo = cardRepo;
    } else if (action is FetchCardDetail) {
      action.collectionRepo = collectionRepo;
      action.cardProgressRepo = cardProgressRepo;
      action.likeRepo = likeRepo;
      action.commentRepo = commentRepo;
      action.cardRepo = cardRepo;
      action.tileRepo = tileRepo;
      action.cardExtraRepo = cardExtraRepo;
    } else if (action is AddProgress) {
      action.cardProgressRepo = cardProgressRepo;
      action.collectionRepo = collectionRepo;
    } else if (action is AddLike) {
      action.likeRepo = likeRepo;
      action.tileRepo = tileRepo;
      action.userRepo = userRepo;
    } else if (action is AddComment) {
      action.commentRepo = commentRepo;
      action.tileRepo = tileRepo;
    } else if (action is SaveDrawing) {
      action.tileRepo = tileRepo;
      action.cardRepo = cardRepo;
    } else if (action is FetchComments) {
      action.commentRepo = commentRepo;
    } else if (action is UpdatePoints) {
      action.userRepo = userRepo;
    } else if (action is PostTile) {
      action.tileRepo = tileRepo;
    } else if (action is FetchTileDetail) {
      action.commentRepo = commentRepo;
    }

    return state;
  }

  @override
  RootState afterAction(ActionType action, RootState state) {
    return state;
  }
}
