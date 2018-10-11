import 'package:flutter/material.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/tile_card.dart';
import 'package:maui/repos/tile_repo.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<Tile> _tiles;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _tiles = await TileRepo().getTiles();
    print(_tiles);
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
    return ListView.builder(
        itemCount: _tiles.length,
        itemBuilder: (context, index) => TileCard(
              tile: _tiles[index],
            ));
  }
}
