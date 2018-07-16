import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/chat_message.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/components/select_emoji.dart';
import 'package:maui/components/select_sticker.dart';
import 'package:maui/db/entity/user.dart';
import 'package:uuid/uuid.dart';
import 'package:flores/flores.dart';

enum InputType { hidden, keyboard, emoji, sticker }

typedef void OnUserPress(String text);

class ChatScreen extends StatefulWidget {
  final String myId;
  final User friend;
  final String friendImageUrl;
  ChatScreen(
      {Key key,
      @required this.myId,
      @required this.friend,
      @required this.friendImageUrl})
      : super(key: key);

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  GlobalKey<AnimatedListState> listKey = new GlobalKey<AnimatedListState>();
  final TextEditingController _textController = new TextEditingController();
  FocusNode _focusNode;
  bool _isComposing = false;
  InputType _inputType = InputType.keyboard;
//  DatabaseReference _reference;
//  List<dynamic> _messages;
  static final chatMessageType = 'chat';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _initMessages();
  }

  void _initMessages() async {
    await AppStateContainer.of(context).beginChat(widget.friend.id);
  }

  @override
  void dispose() {
    AppStateContainer.of(context).endChat();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myId = AppStateContainer.of(context).state.loggedInUser.id;
    final myImage = AppStateContainer.of(context).state.loggedInUser.image;
    var messages = AppStateContainer.of(context).messages;
    print('chat_screen $messages');

    AnimationController controller = AnimationController(vsync: this);
    Animation<double> animation =
        new CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    return Theme(
      data: ThemeData(
          primaryColor: Color(widget.friend.color),
          accentColor: Color(userColors[widget.friend.color]),
          textTheme: TextTheme(body1: TextStyle(fontSize: 24.0))),
      child: new Scaffold(
        backgroundColor: Color(widget.friend.color),
        appBar: new AppBar(
          backgroundColor: Color(userColors[widget.friend.color]),
          title: new Text(widget.friend.name),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: messages == null
            ? Center(
                child: new SizedBox(
                width: 20.0,
                height: 20.0,
                child: new CircularProgressIndicator(),
              ))
            : Column(children: <Widget>[
                new Flexible(
                    child: ListView(
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                  children: messages.map((message) {
                    return message['userId'] == myId
                        ? ChatMessage(
                            animation: animation,
                            side: Side.right,
                            imageFile: myImage,
                            child: new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildMessage(
                                message['message'],
                                Side.right,
                              ),
                            ))
                        : ChatMessage(
                            animation: animation,
                            side: Side.left,
                            imageFile: widget.friendImageUrl,
                            child: new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  _buildMessage(message['message'], Side.left),
                            ));
                  }).toList(growable: false),
                )),
                new Divider(height: 1.0),
                _buildTextComposer(),
              ]),
        bottomNavigationBar: _inputType == InputType.keyboard
            ? null
            : BottomAppBar(
                child: FractionallySizedBox(
                    heightFactor: 0.3, child: _buildBottomBar(_inputType))),
      ),
    );
  }

  Widget _buildMessage(String text, Side side) {
    if (text.startsWith('*s:')) {
      return Image.asset(text.substring(3));
    } else {
      return Text(text,
          style: TextStyle(
              color: side == Side.right ? Colors.black : Colors.white));
    }
  }

  Widget _buildBottomBar(InputType inputType) {
    switch (inputType) {
      case InputType.emoji:
        return SelectEmoji(
          onUserPress: _addText,
        );
        break;
      case InputType.sticker:
        return SelectSticker(
          onUserPress: _addSticker,
        );
        break;
    }
  }

  void _addText(String text) {
    _textController.text += text;
    setState(() {
      _isComposing = true;
    });
  }

  void _addSticker(String text) {
    _sendMessage(text: '*s:$text');
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focusNode.hasFocus.toString());
    if (_focusNode.hasFocus) {
      setState(() {
        _inputType = InputType.keyboard;
      });
    }
  }

  Widget _buildTextComposer() {
    if (_inputType == InputType.keyboard) {
      FocusScope.of(context).requestFocus(_focusNode);
    } else {
      _focusNode.unfocus();
    }
    return IconTheme(
      data: IconThemeData(color: Color(widget.friend.color)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            new Row(children: <Widget>[
              _buildTypeSelector(InputType.keyboard, Icons.keyboard),
              _buildTypeSelector(InputType.emoji, Icons.face),
              _buildTypeSelector(InputType.sticker, Icons.format_paint),
              new Flexible(
                child: new TextField(
                  maxLength: null,
                  keyboardType: TextInputType.multiline,
                  controller: _textController,
                  focusNode: _focusNode,
                  onChanged: (String text) {
                    setState(() {
                      _isComposing = text.trim().isNotEmpty;
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
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(InputType inputType, IconData iconData) {
    return new IconButton(
        icon: Icon(iconData),
        color: _inputType == inputType
            ? Color(widget.friend.color)
            : Color(userColors[widget.friend.color]),
//            ? Colors.green
//            : Colors.red,
        onPressed: () => setState(() {
              _inputType = inputType;
            }));
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text);
  }

  void _sendMessage({String text, String imageUrl}) async {
    AppStateContainer.of(context).addChat(text);
  }
}
