import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/drawing.dart';
import 'package:tahiti/tahiti.dart';
import 'package:maui/repos/activity_template_repo.dart';
import 'package:maui/db/entity/activity_template.dart';
import 'package:maui/repos/drawing_repo.dart';
import 'package:maui/state/app_state_container.dart';

enum DrawingSelect { create, latest, id }

class NewDrawing extends StatefulWidget {
  final String activityId;
  final DrawingSelect drawingSelect;
  final String drawingId;

  const NewDrawing(
      {Key key,
      @required this.activityId,
      this.drawingSelect = DrawingSelect.latest,
      this.drawingId})
      : super(key: key);

  @override
  NewDrawingState createState() {
    return new NewDrawingState();
  }
}

class NewDrawingState extends State<NewDrawing> {
  bool _isLoading = true;
  DrawingSelect _drawingSelect;
  Drawing _drawing;
  List<String> _templates;
  Map<String, dynamic> _jsonMap;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(NewDrawing oldWidget) {
    if (oldWidget.drawingSelect != widget.drawingSelect) {
      _initData();
    }
  }

  void _initData() async {
    setState(() => _isLoading = true);
    _drawingSelect = widget.drawingSelect;
    _jsonMap = null;
    if (widget.drawingSelect == DrawingSelect.latest) {
      _drawing =
          await DrawingRepo().getLatestDrawingByActivityId(widget.activityId);
      if (_drawing == null) _drawingSelect = DrawingSelect.create;
    } else if (widget.drawingSelect == DrawingSelect.id) {
      if (widget.drawingId != null)
        _drawing = await DrawingRepo().getDrawing(widget.drawingId);
      if (_drawing == null) _drawingSelect = DrawingSelect.create;
    }

    if (widget.drawingSelect == DrawingSelect.create) {
      _templates = (await ActivityTemplateRepo()
              .getActivityTemplatesByAtivityId(widget.activityId))
          .map((t) => t.image)
          .toList(growable: false);
    } else {
      _jsonMap = json.decode(_drawing.json);
    }

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
    print('NewDrawing jsonMap: $_jsonMap');
    return ActivityBoard(
      json: _jsonMap,
      templates: _templates,
      saveCallback: ({Map<String, dynamic> jsonMap}) => DrawingRepo().upsert(
          jsonMap: jsonMap,
          activityId: widget.activityId,
          userId: AppStateContainer.of(context).state.loggedInUser.id),
    );
  }
}
