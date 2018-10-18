import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/quack/template_grid.dart';
import 'package:maui/repos/card_extra_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/activity_model.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawingGrid extends StatefulWidget {
  final String cardId;
  final List<Tile> drawings;

  const DrawingGrid({Key key, @required this.cardId, @required this.drawings})
      : super(key: key);

  @override
  DrawingGridState createState() {
    return new DrawingGridState();
  }
}

class DrawingGridState extends State<DrawingGrid> {
  bool _isLoading = true;
  List<String> _templates;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    final activityTemplates = await CardExtraRepo()
        .getCardExtrasByCardIdAndType(widget.cardId, CardExtraType.template);
    _templates =
        activityTemplates.map((t) => t.content).toList(growable: false);
    setState(() => _isLoading = false);
  }

  void _onPressed(BuildContext context) async {
    if ((_templates?.length ?? 0) > 0) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => _buildDialog(context),
      ).then((result) {
        if (result != null) {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => DrawingWrapper(
                      activityId: widget.cardId,
                      template: result.isEmpty ? null : result,
                    )),
          );
        }
      });
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return DrawingWrapper(
          activityId: widget.cardId,
        );
      }));
    }
  }

  Widget _buildDialog(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.all(0.0),
      title: new Container(
          height: MediaQuery.of(context).size.height * .06,
          color: Colors.blue,
          child: new Center(child: new Text("Choose a template"))),
      children: <Widget>[
        new Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 1.6,
            child: TemplateGrid(
              templates: _templates,
            )),
      ],
    );
  }

  List<Widget> _buildList(BuildContext context) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () => _onPressed(context),
          child: Icon(Icons.add_circle),
        ),
      )
    ]..addAll(widget.drawings.map((d) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: DrawingCard(tile: d),
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
            : _buildList(context));
  }
}
