import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:uuid/uuid.dart';

class LoadCommentsAction {
  final String parentId;
  final TileType tileType;

  LoadCommentsAction({this.parentId, this.tileType});
}

class CommentsNotLoadedAction {}

class CommentsLoadedAction {
  final List<Comment> comments;

  CommentsLoadedAction({this.comments});
}

class AddCommentAction {
  final Comment comment;
  final TileType tileType;
  final bool addTile;

  AddCommentAction({this.comment, this.tileType, this.addTile});
}

ThunkAction<RedState> addComment(
    {Comment comment, TileType tileType, bool addTile}) {
  return (Store<RedState> store) async {
    CommentRepo().insert(comment, tileType);

    var tile;

    if (addTile) {
      var tiles = await TileRepo().getTilesByCardId(comment.parentId);
      if (tiles.length == 0) {
        tile = Tile(
          id: Uuid().v4(),
          cardId: comment.parentId,
          type: TileType.card,
          userId: comment.userId,
          updatedAt: DateTime.now(),
        );
        await TileRepo().insert(tile);
      }
    }
    store.dispatch(AddCommentAction(
        addTile: addTile, comment: comment, tileType: tileType));
  };
}

ThunkAction<RedState> loadComments({String parentId, TileType tileType}) {
  return (Store<RedState> store) async {
    CommentRepo().getCommentsByParentId(parentId, tileType).then(
      (comments) {
        store.dispatch(CommentsLoadedAction(
          comments: comments,
        ));
      },
    ).catchError((_) => store.dispatch(CommentsNotLoadedAction()));
  };
}
