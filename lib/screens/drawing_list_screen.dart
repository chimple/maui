import 'package:flutter/material.dart';
import 'package:maui/repos/drawing_repo.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/db/entity/drawing.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/components/drawing_list.dart';

class DrawingListScreen extends StatefulWidget {
  final String activityId;
  DrawingListScreen({Key key, this.activityId}) : super(key: key);

  @override
  DrawingListScreenState createState() {
    return new DrawingListScreenState();
  }
}

class DrawingListScreenState extends State<DrawingListScreen> {
  bool _isLoading = true;
  QuackCard _activity;
  List<Drawing> _drawings;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _activity = await CardRepo().getCard(widget.activityId);
    _drawings = await DrawingRepo().getDrawingsByActivityId(widget.activityId);
    if (_drawings?.length == 0)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (BuildContext context) {
          return DrawingWrapper(
            activityId: widget.activityId,
          );
        }));
      });
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    return new Scaffold(
        appBar: AppBar(
          title: Text(
            _activity.title,
            overflow: TextOverflow.ellipsis,
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add_circle),
              tooltip: 'Create new drawing',
              onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return DrawingWrapper(
                      activityId: widget.activityId,
                    );
                  })),
            )
          ],
        ),
        body: DrawingList(
          drawings: _drawings,
        ));
  }
}
