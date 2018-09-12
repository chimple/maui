import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/repos/drawing_repo.dart';
import 'package:maui/db/entity/drawing.dart';
import 'package:maui/screens/drawing_screen.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/activity_model.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawingList extends StatelessWidget {
  final List<Drawing> drawings;

  const DrawingList({Key key, @required this.drawings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: drawings
          .map((d) => RaisedButton(
                onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                      return DrawingScreen(
                        activityId: d.activityId,
                        drawingId: d.id,
                      );
                    })),
                child: ScopedModel<ActivityModel>(
                  model: ActivityModel.fromJson(json.decode(d.json))
                    ..isInteractive = false,
                  child: Paper(),
                ),
              ))
          .toList(growable: false),
    );
  }
}
