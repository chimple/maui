import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/chat_message.dart';
import 'package:maui/components/join_text.dart';
import 'package:maui/components/text_choice.dart';
import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/lesson_unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:tuple/tuple.dart';

enum ChatItemType { card, text, game }
enum ChatMode { teach, conversation, quiz }

class ChatItem {
  final ChatItemType chatItemType;
  final String content;
  final String sender;
  ChatItem({this.chatItemType, this.content, this.sender});
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
  int _lessonUnitIndex = 0;
  List<ChatItem> _chatItems;
  ScrollController _scrollController = new ScrollController();
  Widget input;
  String _expectedAnswer;
  final botId = 'bot';
  int _currentChatIndex = 0;
  ChatMode _currentMode;
  Map<ChatMode, Tuple2<int, int>> _chatHistory =
      new Map<ChatMode, Tuple2<int, int>>();
  List<LessonUnit> _toQuiz;
  List<LessonUnit> _toTeach;
  LessonUnit _currentQuizLesson;
  User _user;

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
    _lessonUnits = await new LessonUnitRepo()
        .getLessonUnitsByLessonId(_user.currentLessonId);
    _displayNextChat(null);
  }

  @override
  Widget build(BuildContext context) {
    print('build ${_chatItems.length}');
    final botImage = 'assets/koala_neutral.png';

    var widgets = <Widget>[
      new Flexible(
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
                    child: _buildChatMessage(chatItem))
                : new ChatMessage(
                    side: Side.left,
                    animation: animation,
                    imageFile: _user.image,
                    child: _buildChatMessage(chatItem));
          },
        ),
      )
    ];

    if (input != null) {
      widgets.add(new Divider(height: 1.0));
      widgets.add(new Container(
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: input,
      ));
    }
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Chatbot'),
        ),
        body: new Column(children: widgets));
  }

  Widget _buildChatMessage(ChatItem chatItem) {
    switch (chatItem.chatItemType) {
      case ChatItemType.card:
        return new Text(
          chatItem.content,
          style: new TextStyle(fontSize: 48.0),
        );
        break;
      case ChatItemType.text:
        return new Text(
          chatItem.content,
          style: new TextStyle(fontSize: 48.0),
        );
        break;
      case ChatItemType.game:
        return new Text(
          chatItem.content,
        );
        break;
    }
  }

  _handleTextInput(String text) {
    _handleSubmitted(new ChatItem(
        chatItemType: ChatItemType.text, content: text, sender: _user.id));
  }

  _handleSubmitted(ChatItem chatItem) {
    setState(() {
      _chatItems.insert(0, chatItem);
    });
    _animatedListKey.currentState
        .insertItem(0, duration: new Duration(milliseconds: 250));
    input = null;
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
    if ((_toTeach == null || _toTeach.isEmpty) &&
        (_currentMode != ChatMode.conversation ||
            (_currentMode == ChatMode.conversation &&
                _chatHistory[ChatMode.conversation].item2 < 2))) {
      String reply = 'hello';
      if (currentChatItem?.chatItemType == ChatItemType.text) {
        try {
          reply = await platform.invokeMethod(
              'getReply', <String, dynamic>{'query': currentChatItem.content});
        } on PlatformException catch (e) {}
      }
      setState(() {
        _addChatItem(ChatMode.conversation, ChatItemType.card, reply);
        input = new TextField(
          onSubmitted: _handleTextInput,
          autofocus: true,
        );
      });
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
          var question = _currentQuizLesson.objectUnitId;
          _expectedAnswer = _currentQuizLesson.subjectUnitId;
          List<LessonUnit> lessonUnits =
              List.from(_lessonUnits, growable: false)..shuffle();
          List<String> choices = lessonUnits
              .where((l) => l.subjectUnitId != _expectedAnswer)
              .take(3)
              .map((l) => l.objectUnitId)
              .toList(growable: false);
          _addChatItem(ChatMode.quiz, ChatItemType.card, question);
          input = new JoinText(
              answer: _expectedAnswer,
              choices: choices,
              onSubmit: _handleSubmitted);
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
        int index = _currentMode != ChatMode.teach
            ? 0
            : _chatHistory[ChatMode.teach]?.item2 ?? 0;

        setState(() {
          _addChatItem(
              ChatMode.teach, ChatItemType.card, _toTeach[index].subjectUnitId);
          input = new TextChoice(onSubmit: _handleSubmitted);
        });
      }
    }
    _animatedListKey.currentState
        .insertItem(0, duration: new Duration(milliseconds: 250));
  }

  _addChatItem(ChatMode chatMode, ChatItemType chatItemType, String content) {
    _currentChatIndex++;
    var chatHist = _chatHistory[chatMode] ?? new Tuple2(_currentChatIndex, 0);
    _chatHistory[chatMode] = _currentMode == chatMode
        ? new Tuple2(chatHist.item1, chatHist.item2 + 1)
        : new Tuple2(_currentChatIndex, 1);
    _chatItems.insert(
        0,
        new ChatItem(
            sender: botId, chatItemType: chatItemType, content: content));
    _currentMode = chatMode;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
