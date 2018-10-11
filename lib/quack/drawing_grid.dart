import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/repos/drawing_repo.dart';
import 'package:maui/db/entity/drawing.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/activity_model.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawingGrid extends StatefulWidget {
  final String cardId;

  const DrawingGrid({Key key, @required this.cardId}) : super(key: key);

  @override
  DrawingGridState createState() {
    return new DrawingGridState();
  }
}

class DrawingGridState extends State<DrawingGrid> {
  bool _isLoading = true;
  List<Drawing> _drawings;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _drawings = await DrawingRepo().getDrawingsByActivityId(widget.cardId);
    setState(() => _isLoading = false);
  }

  List<Widget> _buildList() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return DrawingWrapper(
                  activityId: widget.cardId,
                );
              })),
          child: Icon(Icons.add_circle),
        ),
      )
    ]..addAll(_drawings.map((d) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return DrawingWrapper(
                    activityId: d.activityId,
                    drawingId: d.id,
                  );
                })),
            child: ScopedModel<ActivityModel>(
              model: ActivityModel(
                  paintData: PaintData.fromJson(json.decode(d.json)))
                ..isInteractive = false,
              child: Paper(),
            ),
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: _isLoading
            ? <Widget>[
                Center(
                    child: new SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: new CircularProgressIndicator(),
                ))
              ]
            : _buildList());
  }
}
