import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/repos/tile_repo.dart';

class UserDrawingGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Connect<RootState, List<Tile>>(
      convert: (state) => state.tiles,
      where: (prev, next) => next != prev,
      builder: (drawings) {
        return GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: DrawingCard(tile: drawings[index]),
            );
          },
          itemCount: drawings.length,
        );
      },
    );
  }
}
