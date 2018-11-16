import 'package:flutter/material.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/tile_card.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/app.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with RouteAware {
  bool _isLoading = true;
  List<Tile> _tiles;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _tiles = await TileRepo().getTilesOtherThanDots();
    print('tiles:$_tiles');
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
    return new Container(
      color: Color(0xFFFFFFFF),
      child: ListView.builder(
          itemCount: _tiles.length,
          itemBuilder: (context, index) => TileCard(
                tile: _tiles[index],
              )),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void didPopNext() {
    _initData();
  }
}
