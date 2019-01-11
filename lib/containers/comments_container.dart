import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/actions/comment_actions.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/quack/comment_list.dart';
import 'package:redux/redux.dart';

class CommentsContainer extends StatelessWidget {
  final String parentId;
  final TileType tileType;
  final bool showInput;

  const CommentsContainer(
      {Key key, this.parentId, this.tileType, this.showInput = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store, parentId),
      builder: (context, vm) {
        if (vm.isLoading)
          return SliverToBoxAdapter(
            child: Center(
              child: new SizedBox(
                width: 20.0,
                height: 20.0,
                child: new CircularProgressIndicator(),
              ),
            ),
          );
        return CommentList(
          parentId: parentId,
          tileType: tileType,
          showInput: showInput,
          comments: vm.comments,
          onAdd: vm.onAdd,
        );
      },
      onInit: (store) =>
          store.dispatch(loadComments(parentId: parentId, tileType: tileType)),
    );
  }
}

class _ViewModel {
  final List<Comment> comments;
  final bool isLoading;
  final Function(Comment, TileType, bool) onAdd;

  _ViewModel({this.comments, this.isLoading, this.onAdd});

  static _ViewModel fromStore(Store<RedState> store, String parentId) {
    return _ViewModel(
      isLoading: store.state.isLoading['comments'],
      comments: store.state.comments[parentId],
      onAdd: (Comment comment, TileType tileType, bool addTile) {
        store.dispatch(
            addComment(comment: comment, tileType: tileType, addTile: addTile));
      },
    );
  }
}
