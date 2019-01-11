import 'package:flutter/material.dart';
import 'package:maui/containers/tiles_container.dart';
import 'package:maui/loca.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
//    final crossAxisCount = (media.size.width / 400.0).floor();
    final crossAxisCount = 2;
    final aspectRatio = media.size.width / (140.0 * crossAxisCount);
    return CustomScrollView(
      slivers: <Widget>[TilesContainer()],
    );
  }

  Widget _buildBox(
      {BuildContext context,
      String name,
      String routeName,
      Widget child,
      Color color}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: routeName == null
                  ? null
                  : () => Navigator.of(context).pushNamed(routeName),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                  color: color,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        routeName == null ? '' : Loca.of(context).seeAll,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
