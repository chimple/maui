import 'package:flutter/material.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/repos/tile_repo.dart';

class UserDrawingGrid extends StatefulWidget {
  final String userId;

  const UserDrawingGrid({Key key, this.userId}) : super(key: key);

  @override
  UserDrawingGridState createState() {
    return new UserDrawingGridState();
  }
}

class UserDrawingGridState extends State<UserDrawingGrid> {
  List<Tile> _drawings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _drawings = await TileRepo()
        .getTilesByUserIdAndType(widget.userId, TileType.drawing);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: new SizedBox(
            width: 20.0,
            height: 20.0,
            child: new CircularProgressIndicator(),
          ))
        : GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DrawingCard(tile: _drawings[index]),
              );
            },
            itemCount: _drawings.length,
          );
  }
}
