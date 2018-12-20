import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/post_tile.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/loca.dart';
import 'package:maui/screens/tab_home.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

class PostComments extends StatefulWidget {
  PostComments({Key key}) : super(key: key);

  @override
  State createState() => new PostCommentsState();
}

class PostCommentsState extends State<PostComments> {
  Tile tile;
  final TextEditingController _textController = new TextEditingController();
  Color _textColor = Colors.grey[400];

  void post(BuildContext context) {
    tile = Tile(
        id: Uuid().v4(),
        userId: AppStateContainer.of(context).state.loggedInUser.id,
        cardId: 'dummy',
        content: _textController.text,
        updatedAt: DateTime.now(),
        type: TileType.message);

    Provider.dispatch<RootState>(context, PostTile(tile: tile));
    _textController.clear();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final user = AppStateContainer.of(context).state.loggedInUser;
    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
            child: new RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.orange,
              onPressed: () =>
                  _textController.text.trim().isEmpty ? {} : post(context),
              textColor: _textColor,
              child: new Text(
                Loca.of(context).post,
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w800),
              ),
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
        backgroundColor: Colors.yellow[700],
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
                        onChanged: (str) {
                          setState(() {
                            _textColor = str.trim().isNotEmpty
                                ? Colors.white
                                : Colors.grey[400];
                          });
                        },
                        autocorrect: false,
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
                            hintText: Loca.of(context).writeSomething),
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
