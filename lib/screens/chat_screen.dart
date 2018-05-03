import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maui/components/chat_message.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String myId;
  final String friendId;
  final String friendImageUrl;
  ChatScreen(
      {Key key,
      @required this.myId,
      @required this.friendId,
      @required this.friendImageUrl})
      : super(key: key);

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  DatabaseReference _reference;

  @override
  void initState() {
    super.initState();
    final chatId = widget.friendId.compareTo(widget.myId) < 0
        ? 'chat_${widget.friendId}_${widget.myId}'
        : 'chat_${widget.myId}_${widget.friendId}';
    print(chatId);
    _reference = FirebaseDatabase.instance.reference().child(chatId);
  }

  @override
  Widget build(BuildContext context) {
    final myId = AppStateContainer.of(context).state.loggedInUser.id;
    final myImage = AppStateContainer.of(context).state.loggedInUser.image;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
              query: _reference,
              sort: (a, b) => b.key.compareTo(a.key),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return snapshot.value['senderId'] == myId
                    ? new ChatMessage(
                        animation: animation,
                        imageFile: myImage,
                        child: snapshot.value['imageUrl'] != null
                            ? new Image.network(
                                snapshot.value['imageUrl'],
                                width: 250.0,
                              )
                            : new Text(snapshot.value['text']))
                    : new ChatMessage(
                        animation: animation,
                        imageUrl: widget.friendImageUrl,
                        child: snapshot.value['imageUrl'] != null
                            ? new Image.network(
                                snapshot.value['imageUrl'],
                                width: 250.0,
                              )
                            : new Text(snapshot.value['text']));
              },
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ]));
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.photo_camera),
                  onPressed: () async {
                    File imageFile =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    var uuid = new Uuid().v4();
                    StorageReference ref =
                        FirebaseStorage.instance.ref().child("image_$uuid.jpg");
                    StorageUploadTask uploadTask = ref.put(imageFile);
                    Uri downloadUrl = (await uploadTask.future).downloadUrl;
                    _sendMessage(imageUrl: downloadUrl.toString());
                  }),
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : new IconButton(
                        icon: new Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border:
                      new Border(top: new BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text);
  }

  void _sendMessage({String text, String imageUrl}) {
    _reference.push().set({
      'text': text,
      'imageUrl': imageUrl,
      'senderId': widget.myId,
    });
  }
}
