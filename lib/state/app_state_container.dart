import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_comment.dart';
import 'package:maui/actions/add_like.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/actions/post_tile.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/repos/lesson_repo.dart';
import 'package:maui/repos/lesson_unit_repo.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/screens/chat_screen.dart';
import 'package:maui/repos/notif_repo.dart';
import 'package:maui/db/entity/notif.dart';
import 'package:maui/db/entity/lesson_unit.dart';
import 'package:maui/db/entity/lesson.dart';
import 'package:maui/repos/chat_bot_data.dart';
import 'package:maui/repos/log_repo.dart';
import 'package:maui/loca.dart';

enum ChatMode { teach, conversation, quiz }

final floresSeparator = '}|~{';

class AppStateContainer extends StatefulWidget {
  final AppState state;
  final Widget child;

  AppStateContainer({this.child, this.state});

  static AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedAppStateContainer)
            as _InheritedAppStateContainer)
        ?.data;
  }

  @override
  AppStateContainerState createState() => new AppStateContainerState();
}

class AppStateContainerState extends State<AppStateContainer> {
  static const platform = const MethodChannel('org.sutara.maui/rivescript');
  static const maxChats = 100;
  AppState state;
  List<dynamic> messages;
  List<dynamic> botMessages;
  String activity;
  String friendId;
  List<User> users;
  List<Notif> notifs = [];
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool isShowingFlashCard = true;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<LessonUnit> _lessonUnits;
  Lesson _lesson;
  int _lessonUnitIndex = 0;
  List<LessonUnit> _toQuiz;
  List<LessonUnit> _toTeach;
  int _currentTeachUnit;
  int _currentQuizUnit;
  ChatMode _currentMode = ChatMode.conversation;
  String _expectedAnswer;
  String extStorageDir;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState();
    }
    try {
      p2p.initialize((Map<dynamic, dynamic> message) {
        print('Flores received message: $message');
        onReceiveMessage(message);
      });
    } on PlatformException {
      print('Flores: Failed initialize');
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
    }
    _initAudioPlayer();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    botMessages = List<dynamic>();
    getExternalStorageDirectory().then((d) => extStorageDir = '${d.path}/');
  }

  void _initAudioPlayer() {
    _audioPlayer = new AudioPlayer();
    _audioPlayer.completionHandler = () => _isPlaying = false;
    _audioPlayer.errorHandler = (msg) => _isPlaying = false;
  }

  Future showNotification(
      String userId, String title, String body, String payload) async {
    User user = await UserRepo().getUser(userId);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'maui_id', 'maui_name', 'maui_description',
        largeIcon: user.image,
        largeIconBitmapSource: BitmapSource.FilePath,
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  Future onSelectNotification(String payload) async {
    var split = payload.split(':');
    if (split[0] == 'chat') {
      User user = await UserRepo().getUser(split[1]);
      await Navigator.push(
          context,
          MaterialPageRoute<Null>(
              builder: (BuildContext context) => new ChatScreen(
                  myId: state.loggedInUser.id,
                  friend: user,
                  friendImageUrl: user.image)));
    }
  }

  void play(String fileName) async {
    fileName = fileName.toLowerCase();
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = new File('$path/$fileName');
      if (await file.exists()) {
        await _audioPlayer.play(file.path, isLocal: true);
      } else {
        await file.writeAsBytes(
            (await rootBundle.load('assets/$fileName')).buffer.asUint8List());
        await _audioPlayer.play(file.path, isLocal: true);
      }
    } catch (e) {
      print('Failed playing $fileName: $e');
    }
  }

  void playWord(String word) async {
    word = word.toLowerCase();
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = new File('$path/$word.ogg');
      if (await file.exists()) {
        await _audioPlayer.play(file.path, isLocal: true);
      } else {
        final name = "assets/dict/$word.ogg";
        File file1 = File(AppStateContainer.of(context).extStorageDir + name);
        await file.writeAsBytes(
            (await rootBundle.load("$file1")).buffer.asUint8List());
        await _audioPlayer.play(file.path, isLocal: true);
      }
    } catch (e) {
      try {
        await platform.invokeMethod('speak', <String, dynamic>{'text': word});
      } on PlatformException catch (e) {}
    }
  }

  void playArticleAudio(String audio, Function onComplete) async {
    audio = audio.toLowerCase();
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = new File('$path/sample.ogg');
      if (await file.exists()) {
        await _audioPlayer.play(file.path, isLocal: true);
      } else {
        await file.writeAsBytes(
            (await rootBundle.load('$audio')).buffer.asUint8List());
        await _audioPlayer.play(file.path, isLocal: true);
      }
    } catch (e) {
      print(e);
    }
    _audioPlayer.completionHandler = () {
      onComplete();
    };
  }

  void pauseArticleAudio() async {
    await _audioPlayer.pause();
  }

  void stopArticleAudio() async {
    await _audioPlayer.stop();
  }

  void display(BuildContext context, String fileName) {
    if (isShowingFlashCard) {
      showDialog(
              context: context,
              child: new FractionallySizedBox(
                  heightFactor: 0.5,
                  widthFactor: 0.8,
                  child: new FlashCard(text: fileName)))
          .whenComplete(() {
        isShowingFlashCard = true;
      });
    } else {
      null;
    }
    isShowingFlashCard = false;
  }

  Future<void> beginChat(String fId) async {
    List<dynamic> msgs;
    friendId = fId;
    activity = 'chat';
    if (fId == User.botId) {
      setState(() {
        messages = botMessages;
      });
    } else {
      try {
        msgs =
            await p2p.getConversations(state.loggedInUser.id, friendId, 'chat');
      } on PlatformException {
        print('Failed getting messages');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }
      msgs ??= List<Map<String, String>>();
      await NotifRepo().delete(fId, 'chat');
      setState(() {
        messages = msgs.reversed.toList(growable: true);
      });
    }
  }

  void endChat() {
    setState(() {
      friendId = '';
      activity = '';
      messages = List<Map<String, String>>();
    });
  }

  void addChat(String message) async {
    writeLog('chat,${state.loggedInUser.id},${friendId},$message');
    if (friendId == User.botId) {
      if (botMessages.length > maxChats * 2)
        botMessages.removeRange(maxChats, botMessages.length);
      botMessages
          .insert(0, {'userId': state.loggedInUser.id, 'message': message});
      final msg = await _respondToChat(message);
      botMessages.insert(0, msg);
    } else {
      try {
        await p2p.addMessage(
            state.loggedInUser.id, friendId, 'chat', message, true, '');
      } on PlatformException {
        print('Flores: Failed addChat');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }
    }
    beginChat(friendId);
  }

  void onReceiveMessage(Map<dynamic, dynamic> message) async {
    writeLog(
        "msg,${message['userId']},${message['messageType']},${message['message']}}");
    if (!(message['userId'] == friendId &&
        activity == 'chat' &&
        message['messageType'] == 'chat')) {
//      await NotifRepo().increment(message['userId'], message['messageType'], 1);
    }
    if (message['messageType'] == 'Photo') {
      await UserRepo().insertOrUpdateRemoteUser(
          message['userId'], message['deviceId'], message['message']);
      if (activity == 'friends') {
        getUsers();
      }
    } else if (message['messageType'] == 'like') {
      String content = message['message'];
      final msgList = content.split(floresSeparator);
      if (msgList?.length == 2) {
        Provider.dispatch<RootState>(
            context,
            AddLike(
                parentId: msgList[1],
                tileType: TileType.values[int.parse(msgList[0])],
                userId: message['userId']));
      }
    } else if (message['messageType'] == 'tile') {
      String content = message['message'];
      final msgList = content.split(floresSeparator);
      if (msgList?.length >= 4) {
        final tile = Tile(
            id: msgList[0],
            type: TileType.values[int.parse(msgList[1])],
            cardId: msgList[2],
            content: msgList[3],
            userId: message['userId'],
            updatedAt: DateTime.now());
        Provider.dispatch<RootState>(context, PostTile(tile: tile));
      }
    } else if (message['messageType'] == 'comment') {
      String content = message['message'];
      final msgList = content.split(floresSeparator);
      print(msgList);
      if (msgList?.length >= 4) {
        final comment = Comment(
            id: msgList[0],
            parentId: msgList[2],
            comment: msgList[3],
            userId: message['userId'],
            timeStamp: DateTime.now());
        Provider.dispatch<RootState>(
            context,
            AddComment(
                comment: comment,
                tileType: TileType.values[int.parse(msgList[1])]));
      }
    } else if (message['recipientUserId'] == state.loggedInUser?.id) {
//      NotifRepo().increment(message['userId'], message['messageType'], 1);
      if (message['messageType'] == 'chat') {
//        showNotification(
//            message['userId'],
//            message['messageType'],
//            message['message'],
//            message['messageType'] + ':' + message['userId']);
        if (message['userId'] == friendId && activity == 'chat') {
          beginChat(friendId);
        }
      } else {
//        showNotification(message['userId'], message['messageType'], '',
//            message['messageType'] + ':' + message['userId']);
      }
    }
  }

  Future<void> getUsers() async {
    activity = 'friends';
    final userList = await UserRepo().getRemoteUsers();
    final botUser = await UserRepo().getUser(User.botId);
    userList.insert(0, botUser);
//    final notifList = await NotifRepo().getNotifsByType('chat');
    setState(() {
      users = userList;
//      notifs = notifList;
    });
  }

  Future<Map<String, dynamic>> _respondToChat(String message) async {
    if (message == Loca().letUsLearn) {
      _currentMode = ChatMode.teach;
    } else if (message == Loca().letUsChat) {
      _currentMode = ChatMode.conversation;
    } else if (_currentMode == ChatMode.quiz) {
      if (message.startsWith(floresSeparator)) message = message.substring(3);
      if (message != _expectedAnswer) {
        _toTeach.add(_toQuiz[_currentQuizUnit]);
      }
      _currentQuizUnit = (_currentQuizUnit + 1) % _toQuiz.length;
      if (_currentQuizUnit == 0) {
        _currentMode = ChatMode.teach;
        _currentTeachUnit = 0;
      }
    } else if (_currentMode == ChatMode.teach) {
      _currentTeachUnit = (_currentTeachUnit + 1) % _toTeach.length;
      if (_currentTeachUnit == 0) {
        _currentMode = ChatMode.quiz;
        _toQuiz = List.from(_toTeach)..shuffle();
        _toTeach = [];
        _currentQuizUnit = 0;
      }
    }
    switch (_currentMode) {
      case ChatMode.conversation:
        String reply = getPossibleReplies(message, 1).first;
        List<String> possibleReplies = getPossibleReplies(reply, 4);
        possibleReplies.insert(0, Loca().letUsLearn);
        return {
          'userId': User.botId,
          'message': reply,
          'choices': possibleReplies
        };
      case ChatMode.teach:
        LessonUnit lessonUnit;
        if (_toTeach == null || _toTeach.isEmpty) {
          if (_lessonUnitIndex >= _lessonUnits.length) {
            if (state.loggedInUser.currentLessonId < Lesson.maxLessonId) {
              state.loggedInUser.currentLessonId++;
              await UserRepo().update(state.loggedInUser);
              _lessonUnits = await new LessonUnitRepo()
                  .getLessonUnitsByLessonId(state.loggedInUser.currentLessonId);
            }
            _lessonUnitIndex = 0;
          }
          _toTeach = _lessonUnits.skip(_lessonUnitIndex).take(4).toList();
          _lessonUnitIndex += 4;
          _currentTeachUnit = 0;
        }
        String msg = '$cardPrefix${_toTeach[_currentTeachUnit].subjectUnitId}';
        if (_toTeach[_currentTeachUnit].objectUnitId != null &&
            _toTeach[_currentTeachUnit].objectUnitId.isNotEmpty)
          msg += '$cardPrefix${_toTeach[_currentTeachUnit].objectUnitId}';
        return {
          'userId': User.botId,
          'message': msg,
          'choices': [Loca().ok, '👍', '😀', Loca().letUsChat]
        };
      case ChatMode.quiz:
        String question;
        List<String> choices;
        if (_lesson.conceptId == 3 || _lesson.conceptId == 5) {
          question = _toQuiz[_currentQuizUnit].objectUnitId;
          _expectedAnswer = question;
          List<LessonUnit> lessonUnits =
              List.from(_lessonUnits, growable: false)..shuffle();
          choices = lessonUnits
              .where((l) => l.objectUnitId != _expectedAnswer)
              .take(3)
              .map((l) => l.objectUnitId)
              .toList();
        } else {
          question = _toQuiz[_currentQuizUnit].objectUnitId?.length > 0
              ? _toQuiz[_currentQuizUnit].objectUnitId
              : _toQuiz[_currentQuizUnit].subjectUnitId;
          _expectedAnswer = _toQuiz[_currentQuizUnit].subjectUnitId;
          List<LessonUnit> lessonUnits =
              List.from(_lessonUnits, growable: false)..shuffle();
          choices = lessonUnits
              .where((l) => l.subjectUnitId != _expectedAnswer)
              .take(3)
              .map((l) =>
                  l.objectUnitId?.length > 0 ? l.objectUnitId : l.subjectUnitId)
              .toList();
        }
        choices.insert(new Random().nextInt(choices.length), _expectedAnswer);
        return {
          'userId': User.botId,
          'message': question,
          'choices':
              choices.map((c) => '$imagePrefix$c').toList(growable: false)
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedAppStateContainer(
      data: this,
      child: widget.child,
    );
  }

  setLoggedInUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    prefs.setString('userId', user.id);
    if (user != null) {
      try {
        p2p.loggedInUser(user.id, deviceId);
      } on PlatformException {
        print('Flores: Failed loggedInUser');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }
    }
    Provider.dispatch<RootState>(context, FetchInitialData(user));

//    try {
//      p2p.start();
//    } on PlatformException {
//      print('Flores: Failed start');
//    } catch (e, s) {
//      print('Exception details:\n $e');
//      print('Stack trace:\n $s');
//    }
    _lessonUnits = await new LessonUnitRepo().getLessonUnitsByLessonId(56);
    _lesson = await new LessonRepo().getLesson(56);
//    _lessonUnits = await new LessonUnitRepo()
//        .getLessonUnitsByLessonId(user.currentLessonId);
//    _lesson = await new LessonRepo().getLesson(user.currentLessonId);
    setState(() {
      state = new AppState(loggedInUser: user);
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }
}

class _InheritedAppStateContainer extends InheritedWidget {
  final AppStateContainerState data;

  _InheritedAppStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_InheritedAppStateContainer old) => true;
}
