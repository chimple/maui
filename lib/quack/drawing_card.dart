import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/paper.dart';

class DrawingCard extends StatelessWidget {
  final Tile tile;

  const DrawingCard({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('drawing_card:build: $tile');
    return RaisedButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return DrawingWrapper(
              activityId: tile.cardId,
              drawingId: tile.id,
            );
          })),
      child: ScopedModel<ActivityModel>(
        model: ActivityModel(
            extStorageDir: AppStateContainer.of(context).extStorageDir,
            paintData: PaintData.fromJson(json.decode(tile.content)))
          ..isInteractive = false,
        child: Paper(),
      ),
    );
  }
}
