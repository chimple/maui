import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/chat_message.dart';
import 'package:maui/components/join_text.dart';
import 'package:maui/components/text_choice.dart';
import 'package:maui/components/multiple_choice.dart';
import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/lesson.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/lesson_unit_repo.dart';
import 'package:maui/repos/lesson_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/instruction_card.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/chat_bot_data.dart';

enum ChatItemType { card, text, game, image, audio }
enum ChatMode { teach, conversation, quiz }

class ChatItem {
  final ChatItemType chatItemType;
  final String content;
  final String additionalContent;
  final String sender;
  ChatItem(
      {this.chatItemType, this.content, this.sender, this.additionalContent});
}

class ChatBotScreen extends StatefulWidget {
  @override
  State createState() => new ChatBotScreenState();
}

class ChatBotScreenState extends State<ChatBotScreen> {
  static const platform = const MethodChannel('org.sutara.maui/rivescript');
  final GlobalKey<AnimatedListState> _animatedListKey =
      new GlobalKey<AnimatedListState>();

  List<LessonUnit> _lessonUnits;
  Lesson _lesson;
  int _lessonUnitIndex = 0;
  List<ChatItem> _chatItems;
  ScrollController _scrollController = new ScrollController();
  List<String> _choices;
  String _expectedAnswer;
  final botId = 'bot';
  int _currentChatIndex = 0;
  ChatMode _currentMode;
  Map<ChatMode, Tuple2<int, int>> _chatHistory =
      new Map<ChatMode, Tuple2<int, int>>();
  List<LessonUnit> _toQuiz;
  List<LessonUnit> _toTeach;
  int _currentTeachUnit;
  LessonUnit _currentQuizLesson;
  User _user;
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  bool _isKeyboard = false;

  @override
  void initState() {
    super.initState();
    _chatItems = [
      new ChatItem(
          sender: botId, chatItemType: ChatItemType.text, content: 'Hi')
    ];
    _initState();
  }

  void _initState() async {
    _user = AppStateContainer.of(context).state.loggedInUser;
    _lessonUnits = await new LessonUnitRepo().getLessonUnitsByLessonId(56);
//        .getLessonUnitsByLessonId(_user.currentLessonId);
    _lesson = await new LessonRepo().getLesson(_user.currentLessonId);
    _displayNextChat(null);
  }

  @override
  Widget build(BuildContext context) {
    print('build ${_chatItems.length}');
    print(_isComposing);
    final botImage = 'assets/chat_Bot_Icon.png';

    var widgets = <Widget>[
      new Flexible(
        flex: 2,
        child: new AnimatedList(
          key: _animatedListKey,
          scrollDirection: Axis.vertical,
          reverse: true,
          padding: new EdgeInsets.all(8.0),
          controller: _scrollController,
          initialItemCount: _chatItems.length,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            var chatItem = _chatItems[index];
            return chatItem.sender == botId
                ? new ChatMessage(
                    side: Side.right,
                    animation: animation,
                    imageAsset: botImage,
                    child: _buildChatMessage(context, chatItem))
                : new ChatMessage(
                    side: Side.left,
                    animation: animation,
                    imageFile: _user.image,
                    child: _buildChatMessage(context, chatItem));
          },
        ),
      ),
      new Divider(height: 1.0),
      _buildInput()
    ];

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Hoodie'),
        ),
        body: new Column(children: widgets));
  }

  Widget _buildInput() {
    print(_isComposing);
    if (_currentMode == ChatMode.conversation) {
      return new IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: new Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: new IconButton(
                        icon: _isKeyboard
                            ? new Icon(Icons.face)
                            : Icon(Icons.keyboard),
                        onPressed: () => setState(() {
                              _isKeyboard = !_isKeyboard;
                            }))),
                Flexible(
                    child: _isKeyboard
                        ? TextField(
                            maxLength: null,
                            keyboardType: TextInputType.multiline,
                            autofocus: true,
                            controller: _textController,
                            onChanged: (String text) {
                              setState(() {
                                _isComposing = text.length > 0;
                              });
                            },
                          )
                        : Container()),
                new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleTextInput(_textController.text)
                          : null,
                    ))
              ],
            ),
            _isKeyboard
                ? Container()
                : TextChoice(
                    onSubmit: _handleSubmitted,
                    texts: getPossibleReplies(_chatItems[0].content, 5),
                  )
          ],
        ),
      );
    } else if (_currentMode == ChatMode.quiz) {
      return new IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: new MultipleChoice(
            answer: _expectedAnswer,
            choices: _choices,
            onSubmit: _handleSubmitted),
      );
    } else if (_currentMode == ChatMode.teach) {
      return new IconTheme(
          data: IconThemeData(color: Theme.of(context).accentColor),
          child: new TextChoice(
              onSubmit: _handleSubmitted,
              texts: [_toTeach[_currentTeachUnit].subjectUnitId]));
    }
    return Expanded(flex: 1, child: Container());
  }

  Widget _buildChatMessage(BuildContext context, ChatItem chatItem) {
    MediaQueryData media = MediaQuery.of(context);
    final size = min(media.size.height, media.size.width) / 2;
    final textStyle = TextStyle(
        color: chatItem.sender == _user?.id ? Colors.white : Colors.black);
    switch (chatItem.chatItemType) {
      case ChatItemType.card:
        var cards = [
          new SizedBox(
              width: size,
              height: size,
              child: InstructionCard(text: chatItem.content))
        ];
        if ((chatItem.additionalContent?.length ?? 0) > 0 &&
            chatItem.content != chatItem.additionalContent) {
          cards.add(new SizedBox(
              width: size,
              height: size,
              child: InstructionCard(text: chatItem.additionalContent)));
        }
        return media.size.height > media.size.width
            ? Column(children: cards)
            : Row(children: cards);
        break;
      case ChatItemType.text:
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(chatItem.content, style: textStyle),
        );
        break;
      case ChatItemType.image:
        return new UnitButton(
          text: chatItem.content,
          unitMode: UnitMode.image,
          maxHeight: size,
          maxWidth: size,
          fontSize: 14.0,
        );
      case ChatItemType.audio:
        return new UnitButton(
          text: chatItem.content,
          unitMode: UnitMode.audio,
          maxHeight: size,
          maxWidth: size,
          fontSize: 14.0,
        );
      case ChatItemType.game:
        return new Text(chatItem.content, style: textStyle);
        break;
    }
  }

  _handleTextInput(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _handleSubmitted(new ChatItem(
        chatItemType: ChatItemType.text, content: text, sender: _user.id));
  }

  _handleSubmitted(ChatItem chatItem) {
    setState(() {
      _chatItems.insert(0, chatItem);
    });
    _animatedListKey.currentState
        .insertItem(0, duration: new Duration(milliseconds: 250));
    if (_expectedAnswer != null) {
      ChatItem response;
      if (chatItem.content == _expectedAnswer) {
        response = new ChatItem(
            chatItemType: ChatItemType.text,
            content: 'Awesome!',
            sender: botId);
        _toTeach.remove(_currentQuizLesson);
      } else {
        response = new ChatItem(
            chatItemType: ChatItemType.text,
            content: 'Too bad!',
            sender: botId);
      }
      setState(() {
        _chatItems.insert(0, response);
      });
      _animatedListKey.currentState
          .insertItem(0, duration: new Duration(milliseconds: 250));
      _expectedAnswer = null;
    }
    new Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _displayNextChat(chatItem);
    });
  }

  _displayNextChat(ChatItem currentChatItem) async {
    if (_currentMode == ChatMode.conversation &&
        currentChatItem?.chatItemType == ChatItemType.text) {
      try {
        final reply = await platform.invokeMethod(
            'getReply', <String, dynamic>{'query': currentChatItem.content});
        _addChatItem(ChatMode.conversation, ChatItemType.text, reply);
      } on PlatformException catch (e) {}
    }
    if ((_toTeach == null || _toTeach.isEmpty) &&
        _currentMode != ChatMode.conversation) {
      _addChatItem(ChatMode.conversation, ChatItemType.text, 'Let us chat');
    } else if ((_toTeach == null || _toTeach.isEmpty) &&
        _currentMode == ChatMode.conversation &&
        _chatHistory[ChatMode.conversation].item2 < 4) {
      String reply = 'hello';
//      if (currentChatItem?.chatItemType == ChatItemType.text) {
//        try {
//          reply = await platform.invokeMethod(
//              'getReply', <String, dynamic>{'query': currentChatItem.content});
//        } on PlatformException catch (e) {}
//      }
//      _addChatItem(ChatMode.conversation, ChatItemType.text, reply);
    } else {
      if ((_currentMode == ChatMode.teach &&
              _chatHistory[ChatMode.teach].item2 >= _toTeach.length) ||
          (_currentMode == ChatMode.quiz &&
              _chatHistory[ChatMode.quiz].item2 < _toQuiz.length)) {
        print('Current: $_currentMode Next: quiz History: $_chatHistory');
        if (_currentMode != ChatMode.quiz) {
          _toQuiz = List.from(_toTeach)..shuffle();
        }
        int index = _currentMode != ChatMode.quiz
            ? 0
            : _chatHistory[ChatMode.quiz]?.item2 ?? 0;

        setState(() {
          _currentQuizLesson = _toQuiz[index];
          String question;
          if (_lesson.conceptId == 3 || _lesson.conceptId == 5) {
            question = _currentQuizLesson.objectUnitId;
            _expectedAnswer = question;
            List<LessonUnit> lessonUnits =
                List.from(_lessonUnits, growable: false)..shuffle();
            _choices = lessonUnits
                .where((l) => l.objectUnitId != _expectedAnswer)
                .take(3)
                .map((l) => l.objectUnitId)
                .toList(growable: false);
          } else {
            question = _currentQuizLesson.objectUnitId?.length > 0
                ? _currentQuizLesson.objectUnitId
                : _currentQuizLesson.subjectUnitId;
            _expectedAnswer = _currentQuizLesson.subjectUnitId;
            List<LessonUnit> lessonUnits =
                List.from(_lessonUnits, growable: false)..shuffle();
            _choices = lessonUnits
                .where((l) => l.subjectUnitId != _expectedAnswer)
                .take(3)
                .map((l) => l.objectUnitId?.length > 0
                    ? l.objectUnitId
                    : l.subjectUnitId)
                .toList(growable: false);
          }
          final chatItemType = <ChatItemType>[
            ChatItemType.text,
            ChatItemType.audio,
            ChatItemType.image
          ][new Random().nextInt(3)];
          _addChatItem(ChatMode.quiz, chatItemType, question);
        });
      } else {
        print('Current: $_currentMode Next: teach History: $_chatHistory');
        if (_currentMode != ChatMode.teach) {
          if (_toTeach == null || _toTeach.isEmpty) {
            if (_lessonUnitIndex >= _lessonUnits.length) {
              //TODO: decide to progress the user's lesson or not
              _lessonUnits = await new LessonUnitRepo()
                  .getLessonUnitsByLessonId(_user.currentLessonId);
              _lessonUnitIndex = 0;
            }
            _toTeach = _lessonUnits.skip(_lessonUnitIndex).take(4).toList();
            _lessonUnitIndex += 4;
          }
        }
        _currentTeachUnit = _currentMode != ChatMode.teach
            ? 0
            : _chatHistory[ChatMode.teach]?.item2 ?? 0;

        _addChatItem(ChatMode.teach, ChatItemType.card,
            _toTeach[_currentTeachUnit].subjectUnitId,
            additionalContent: _toTeach[_currentTeachUnit].objectUnitId);
      }
    }
    _animatedListKey.currentState
        .insertItem(0, duration: new Duration(milliseconds: 250));
  }

  _addChatItem(ChatMode chatMode, ChatItemType chatItemType, String content,
      {String additionalContent}) {
    setState(() {
      _currentChatIndex++;
      var chatHist = _chatHistory[chatMode] ?? new Tuple2(_currentChatIndex, 0);
      _chatHistory[chatMode] = _currentMode == chatMode
          ? new Tuple2(chatHist.item1, chatHist.item2 + 1)
          : new Tuple2(_currentChatIndex, 1);
      _chatItems.insert(
          0,
          new ChatItem(
              sender: botId,
              chatItemType: chatItemType,
              content: content,
              additionalContent: additionalContent));
      _currentMode = chatMode;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
