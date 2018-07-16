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
import 'package:uuid/uuid.dart';
import 'package:flores/flores.dart';

enum InputType { hidden, keyboard, emoji, sticker }

typedef void OnUserPress(String text);

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
    final chatId = widget.friendId.compareTo(widget.myId) < 0
        ? 'chat_${widget.friendId}_${widget.myId}'
        : 'chat_${widget.myId}_${widget.friendId}';
    print(chatId);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _initMessages();
  }

  void _initMessages() async {
    await AppStateContainer.of(context).beginChat(widget.friendId);
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendlychat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
                            child: _buildMessage(message['message'], Side.left),
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
    return Column(
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
    );
  }

  Widget _buildTypeSelector(InputType inputType, IconData iconData) {
    return new IconButton(
        icon: Icon(iconData),
        color: _inputType == inputType
//                ? Theme.of(context).accentColor
//                : Theme.of(context).primaryColor,
            ? Colors.green
            : Colors.red,
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
