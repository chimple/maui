import 'dart:async';
import 'dart:math';
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
import 'package:maui/components/instruction_card.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/select_text_choice.dart';
import 'package:maui/repos/chat_bot_data.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:maui/loca.dart';

enum InputType { hidden, keyboard, emoji, sticker, choices }

typedef void OnUserPress(String text);

final stickerPrefix = '*s:';
final cardPrefix = '*c:';
final imagePrefix = '*i:';
final audioPrefix = '*a:';

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
  InputType _inputType = InputType.choices;
//  DatabaseReference _reference;
//  List<dynamic> _messages;
  static final chatMessageType = 'chat';
  bool _isLoading = true;
  AppStateContainerState appStateContainerState;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _initMessages();
  }

  void _initMessages() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppStateContainer.of(context).beginChat(widget.friend.id);
    });
  }

  @override
  void dispose() {
    appStateContainerState.endChat();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appStateContainerState = AppStateContainer.of(context);
    final myId = appStateContainerState.state.loggedInUser.id;
    final myImage = appStateContainerState.state.loggedInUser.image;
    var messages = appStateContainerState.messages;
    print('chat_screen $messages');
    var latestMessage = Map<String, dynamic>();
    try {
      latestMessage = messages.first;
    } catch (e) {
      print(e);
    }

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
          title: new Text(widget.friend.name ?? ''),
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
            : GestureDetector(
                onTap: () {
                  setState(() {
                    _inputType = InputType.hidden;
                  });
                },
                child: Column(children: <Widget>[
                  new Flexible(
                      child: ListView(
                    reverse: true,
                    padding: EdgeInsets.all(8.0),
                    children: messages.map((message) {
                      return ChatMessage(
                          animation: animation,
                          side: message['userId'] == myId
                              ? Side.right
                              : Side.left,
                          imageFile: message['userId'] == myId
                              ? myImage
                              : widget.friendImageUrl,
                          child: new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildMessage(
                              message['message'],
                              message['userId'] == myId
                                  ? Side.right
                                  : Side.left,
                            ),
                          ));
                    }).toList(growable: false),
                  )),
                  new Divider(height: 1.0),
                  _buildTextComposer(),
                ]),
              ),
        bottomNavigationBar:
            _inputType == InputType.keyboard || _inputType == InputType.hidden
                ? null
                : BottomAppBar(
                    child: FractionallySizedBox(
                        heightFactor: 0.3,
                        child: _buildBottomBar(_inputType, latestMessage))),
      ),
    );
  }

  Widget _buildMessage(String text, Side side) {
    MediaQueryData media = MediaQuery.of(context);
    final size = min(media.size.height, media.size.width) / 2;
    if (text.startsWith(stickerPrefix)) {
      return Image.asset(text.substring(3));
    } else if (text.startsWith(cardPrefix)) {
      final contents = text.substring(3).split(cardPrefix);
      var cards = [
        new SizedBox(
            width: size,
            height: size,
            child: InstructionCard(text: contents[0]))
      ];
      if (contents.length > 1 && contents[0] != contents[1]) {
        cards.add(new SizedBox(
            width: size,
            height: size,
            child: InstructionCard(text: contents[1])));
      }
      return media.size.height > media.size.width
          ? Column(children: cards)
          : Row(children: cards);
    } else if (text.startsWith(imagePrefix)) {
      return new UnitButton(
        text: text.substring(3),
        unitMode: UnitMode.image,
        maxHeight: size,
        maxWidth: size,
        fontSize: 24.0,
      );
    } else if (text.startsWith(audioPrefix)) {
      return new UnitButton(
        text: text.substring(3),
        unitMode: UnitMode.audio,
        maxHeight: size,
        maxWidth: size,
        fontSize: 24.0,
      );
    } else {
      return Card(
          color:
              side == Side.left ? Theme.of(context).accentColor : Colors.white,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,
                style: TextStyle(
                    color: side == Side.right ? Colors.black : Colors.white)),
          ));
    }
  }

  Widget _buildBottomBar(InputType inputType, Map<String, dynamic> message) {
    print('ChatScreen._buildBottomBar');
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
      case InputType.choices:
        return SelectTextChoice(
            onUserPress: _addTextChoice, texts: message['choices']);
    }
  }

  void _addText(String text) {
    _textController.text += text;
    setState(() {
      _isComposing = true;
    });
  }

  void _addTextChoice(String text) {
    _sendMessage(text: text);
  }

  void _addSticker(String text) {
    _sendMessage(text: '$stickerPrefix$text');
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
              _buildTypeSelector(InputType.choices, Icons.apps),
              _buildTypeSelector(InputType.keyboard, Icons.keyboard),
              _buildTypeSelector(InputType.emoji, Icons.face),
              _buildTypeSelector(InputType.sticker, Icons.format_paint)
            ]),
            Row(children: <Widget>[
              Flexible(
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
                  decoration: new InputDecoration.collapsed(
                      hintText: Loca().sendAMessage),
                ),
              ),
              Container(
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: new IconButton(
          icon: Icon(iconData,
              color: _inputType == inputType
                  ? Color(userColors[widget.friend.color])
                  : Color(widget.friend.color)),
          onPressed: () => setState(() {
                _inputType = inputType;
              })),
    );
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
