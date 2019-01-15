import 'package:flutter/material.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/loca.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/quack/template_grid.dart';

//TODO: pass drawings and templates
class ActivityDrawingGrid extends StatelessWidget {
  final String cardId;
  final List drawings;
  final List<CardExtra> templates;

  const ActivityDrawingGrid(
      {Key key, this.cardId, this.drawings, this.templates})
      : super(key: key);

  void _onPressed(BuildContext context, List<CardExtra> templates) async {
    if ((templates?.length ?? 0) > 0) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => _buildDialog(context, templates),
      ).then((result) {
        if (result != null) {
          Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) => DrawingWrapper(
                      activityId: cardId,
                      template: result.isEmpty ? null : result,
                    )),
          );
        }
      });
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return DrawingWrapper(
          activityId: cardId,
        );
      }));
    }
  }

  Widget _buildDialog(BuildContext context, List<CardExtra> templates) {
    return SimpleDialog(
      titlePadding: EdgeInsets.all(0.0),
      title: new Container(
          height: MediaQuery.of(context).size.height * .06,
          color: Colors.blue,
          child: new Center(child: new Text(Loca.of(context).chooseATemplate))),
      children: <Widget>[
        new Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 1.6,
            child: TemplateGrid(
              templates:
                  templates.map((c) => c.content).toList(growable: false),
            )),
      ],
    );
  }

  List<Widget> _buildList(
      BuildContext context, List<Tile> drawings, List<CardExtra> templates) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () => _onPressed(context, templates),
          child: Icon(Icons.add_circle),
        ),
      )
    ]..addAll(drawings.map((d) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: DrawingCard(tile: d),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: _buildList(context, drawings, templates));
  }
}
