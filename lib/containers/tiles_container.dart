import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/actions/tile_actions.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/quack/tile_list.dart';
import 'package:redux/redux.dart';

class TilesContainer extends StatelessWidget {
  const TilesContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedState, _ViewModel>(
      converter: _ViewModel.fromStore,
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
        return TileList(
          tiles: vm.tiles,
        );
      },
      onInit: (store) => store.dispatch(loadTiles()),
    );
  }
}

class _ViewModel {
  final List<Tile> tiles;
  final bool isLoading;

  _ViewModel({this.tiles, this.isLoading});

  static _ViewModel fromStore(Store<RedState> store) {
    return _ViewModel(
      isLoading: store.state.isLoading['tiles'],
      tiles: store.state.tiles,
    );
  }
}
