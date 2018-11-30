import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/drawing_card.dart';
import 'package:maui/quack/template_grid.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/card_extra_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/activity_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tuple/tuple.dart';

class ActivityDrawingGrid extends StatelessWidget {
  final String cardId;

  const ActivityDrawingGrid({Key key, this.cardId}) : super(key: key);

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
    return Connect<RootState, Tuple2<List<Tile>, List<CardExtra>>>(
      convert: (state) => Tuple2(state.drawings, state.templates),
      where: (prev, next) => next != prev,
      builder: (props) {
        return SliverGrid.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            children: _buildList(context, props?.item1 ?? [], props?.item2));
      },
      nullable: true,
    );
  }
}
