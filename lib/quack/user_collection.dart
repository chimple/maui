import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/quack/drawing_lock.dart';
import 'package:maui/repos/tile_repo.dart';

class UserCollection extends StatefulWidget {
  final String userId;

  const UserCollection({Key key, this.userId}) : super(key: key);

  @override
  UserCollectionState createState() {
    return new UserCollectionState();
  }
}

class UserCollectionState extends State<UserCollection> {
  bool _isLoading = true;
  List<Tile> _tiles;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _tiles = await TileRepo()
        .getTilesByCardIdAndUserIdAndType('dummy', widget.userId, TileType.dot);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    return GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: <Widget>[
            DrawingCard(tile: _tiles[index]),
            DrawingLock(
              tile: _tiles[index],
            )
          ]),
        );
      },
      itemCount: _tiles.length,
    );
  }
}
