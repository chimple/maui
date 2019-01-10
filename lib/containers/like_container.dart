import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/actions/activity_actions.dart';
import 'package:maui/actions/card_actions.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/loca.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/like_button.dart';
import 'package:redux/redux.dart';

class LikeContainer extends StatelessWidget {
  final String parentId;
  final TileType tileType;
  final bool isInteractive;

  const LikeContainer(
      {Key key, this.parentId, this.tileType, this.isInteractive = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store, parentId, tileType),
      builder: (context, vm) {
        return LikeButton(
            like: vm.like, onLike: vm.onLike, isInteractive: isInteractive);
      },
    );
  }
}

class _ViewModel {
  final bool like;
  final Function onLike;
  _ViewModel({this.onLike, this.like});

  static _ViewModel fromStore(
      Store<RedState> store, String parentId, TileType tileType) {
    return _ViewModel(
      like: store.state.activityMap[parentId]?.like ?? false,
      onLike: () =>
          store.dispatch(addLike(parentId: parentId, tileType: tileType)),
    );
  }
}
