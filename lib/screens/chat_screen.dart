import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

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
import 'package:flores/flores.dart';

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
  GlobalKey<AnimatedListState> listKey = new GlobalKey<AnimatedListState>();
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
//  DatabaseReference _reference;
  List<dynamic> _messages;
  static final chatMessageType = 'chat';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final chatId = widget.friendId.compareTo(widget.myId) < 0
        ? 'chat_${widget.friendId}_${widget.myId}'
        : 'chat_${widget.myId}_${widget.friendId}';
    print(chatId);
    _initMessages();
//    _reference = FirebaseDatabase.instance.reference().child(chatId);
  }

  void _initMessages() async {
    setState(() => _isLoading = true);
    List<dynamic> messages;
    try {
      messages = await Flores()
          .getConversations(widget.myId, widget.friendId, chatMessageType);
    } on PlatformException {
      print('Failed getting messages');
    }
    print(messages);
    messages ??= List<Map<String, String>>();
    setState(() {
      _isLoading = false;
      _messages = messages.reversed.toList(growable: true);
    });
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
        body: _isLoading
            ? Center(
                child: new SizedBox(
                width: 20.0,
                height: 20.0,
                child: new CircularProgressIndicator(),
              ))
            : Column(children: <Widget>[
                new Flexible(
                    child: AnimatedList(
                  key: listKey,
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                  initialItemCount: _messages.length,
                  itemBuilder: (_, int index, Animation<double> animation) {
                    Map<dynamic, dynamic> message = _messages[index];
                    return message['userId'] == myId
                        ? ChatMessage(
                            animation: animation,
                            side: Side.left,
                            imageFile: myImage,
                            child: new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                message['message'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                        : ChatMessage(
                            animation: animation,
                            side: Side.right,
                            imageUrl: widget.friendImageUrl,
                            isFile: false,
                            child: new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(message['message'],
                                  style: TextStyle(color: Colors.black)),
                            ));
                  },
                )),
                new Divider(height: 1.0),
                new Container(
                  decoration:
                      new BoxDecoration(color: Theme.of(context).cardColor),
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
    Flores().addMessage(widget.myId, widget.friendId, chatMessageType, text);
//    final index = _messages.length;
    listKey.currentState.insertItem(0);
    _messages.insert(0, <String, String>{
      'userId': widget.myId,
      'recipientUserId': widget.friendId,
      'messageType': chatMessageType,
      'message': text,
      'deviceId': 'todo',
      'loggedAt': DateTime.now().millisecondsSinceEpoch.toString()
    });
//    _reference.push().set({
//      'text': text,
//      'imageUrl': imageUrl,
//      'senderId': widget.myId,
//    });
  }
}
