import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/post_tile.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/screens/tab_home.dart';
import 'package:maui/state/app_state_container.dart';

class PostComments extends StatelessWidget {
  Tile tile;
  var user;
  final TextEditingController _textController = new TextEditingController();

  void post(BuildContext context) {
    tile = Tile(
        userId: AppStateContainer.of(context).state.loggedInUser.id,
        cardId: 'dummy',
        content: _textController.text,
        updatedAt: DateTime.now(),
        type: TileType.message);

    Provider.dispatch<RootState>(context, PostTile(tile: tile));
    Navigator.push(context, MaterialPageRoute(builder: (context) => TabHome()));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    user = AppStateContainer.of(context).state.loggedInUser;

    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new FlatButton(
            onPressed: () => _textController.text.isEmpty ? {} : post(context),
            textColor: Colors.white,
            child: new Text(
              "Post  ",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
        ],
        leading: new IconButton(
          icon: new Center(
              child: new Icon(
            Icons.cancel,
            size: 40.0,
          )),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: EdgeInsets.all(size.width * .02),
        child: Column(children: [
          new Flexible(
              child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      minRadius: 30.0,
                      backgroundImage: new FileImage(new File(user.image)),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: new TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                            fillColor: Colors.grey[110],
                            filled: true,
                            border: InputBorder.none,
                            hintText: 'Write Something '),
                        autofocus: true,
                        maxLength: null,
                        maxLines: 7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ])),
        ]),
      ),
    );
  }
}
