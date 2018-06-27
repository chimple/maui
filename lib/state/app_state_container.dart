import 'dart:io';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flores/flores.dart';
import 'package:maui/repos/user_repo.dart';
import '../components/flash_card.dart';

class AppStateContainerController extends StatefulWidget {
  final AppState state;
  final Widget child;

  AppStateContainerController({this.child, this.state});

  @override
  State<StatefulWidget> createState() =>
      new _AppStateContainerControllerState();
}

class _AppStateContainerControllerState
    extends State<AppStateContainerController> {
  static const platform = const MethodChannel('org.sutara.maui/rivescript');

  AppState state;
  List<dynamic> messages;
  String activity;
  String friendId;
  List<User> users;
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool isShowingFlashCard = true;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new AppState();
    }
    Flores().initialize((Map<dynamic, dynamic> message) {
      print('Flores received message: $message');
      _onReceiveMessage(message);
    });
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = new AudioPlayer();
    _audioPlayer.setCompletionHandler(() {
      _isPlaying = false;
    });
    _audioPlayer.setErrorHandler((msg) {
      _isPlaying = false;
    });
  }

  void _play(String fileName) async {
    try {
      await platform.invokeMethod(
          'speak', <String, dynamic>{'text': fileName.toLowerCase()});
    } on PlatformException catch (e) {}

//    if (!_isPlaying) {
//      Directory documentsDirectory = await getApplicationDocumentsDirectory();
//      final result = await _audioPlayer
//          .play(join(documentsDirectory.path, 'apple.ogg'), isLocal: true);
//      if (result == 1) {
//        _isPlaying = true;
//      }
//    }
  }

  void _display(BuildContext context, String fileName) {
    if (isShowingFlashCard) {
      showDialog(
          context: context,
          child: new FractionallySizedBox(
              heightFactor: 0.5,
              widthFactor: 0.8,
              child: new FlashCard(text: fileName))).whenComplete(() {
        isShowingFlashCard = true;
      });
    } else {
      null;
    }
    isShowingFlashCard = false;
  }

  void _beginChat(String fId) async {
    List<dynamic> msgs;
    friendId = fId;
    activity = 'chat';
    try {
      msgs = await Flores()
          .getConversations(state.loggedInUser.id, friendId, 'chat');
    } on PlatformException {
      print('Failed getting messages');
    }
    print('_fetchMessages: $msgs');
    msgs ??= List<Map<String, String>>();
    setState(() {
      messages = msgs.reversed.toList(growable: true);
    });
  }

  void _endChat() {
    setState(() {
      friendId = '';
      activity = '';
      messages = List<Map<String, String>>();
    });
  }

  void _addChat(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');

    await Flores()
        .addMessage(state.loggedInUser.id, friendId, 'chat', message, true, '');
    _beginChat(friendId);
  }

  void _onReceiveMessage(Map<dynamic, dynamic> message) async {
    print(
        '_onReceiveMessage $message ${state.loggedInUser.id} $friendId $activity');
    if (message['recipientUserId'] == state.loggedInUser.id &&
        message['userId'] == friendId &&
        message['messageType'] == 'chat' &&
        activity == 'chat') {
      _beginChat(friendId);
    } else if (message['messageType'] == 'Photo' && activity == 'friends') {
      _getUsers();
    }
  }

  void _getUsers() async {
    activity = 'friends';
    final userList = await UserRepo().getUsers();
    setState(() {
      users = userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AppStateContainer(
      state: state,
      messages: messages,
      friendId: friendId,
      activity: activity,
      users: users,
      getUsers: _getUsers,
      setLoggedInUser: _setLoggedInUser,
      play: _play,
      display: _display,
      beginChat: _beginChat,
      endChat: _endChat,
      addChat: _addChat,
      onReceiveMessage: _onReceiveMessage,
      child: widget.child,
    );
  }

  _setLoggedInUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    if (user != null) {
      Flores().loggedInUser(user.id, deviceId);
    }
    Flores().start();
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

class AppStateContainer extends InheritedWidget {
  final AppState state;
  List<dynamic> messages;
  String activity;
  String friendId;
  List<User> users;
  final Function() getUsers;
  final Function(User user) setLoggedInUser;
  final Function(String string) play;
  final Function(BuildContext context, String string) display;
  final Function(String friendId) beginChat;
  final Function() endChat;
  final Function(String message) addChat;
  final Function(Map<dynamic, dynamic> message) onReceiveMessage;

  AppStateContainer({
    Key key,
    @required this.state,
    @required this.messages,
    @required this.friendId,
    @required this.activity,
    @required this.users,
    @required this.getUsers,
    @required this.setLoggedInUser,
    @required this.play,
    @required this.display,
    @required this.beginChat,
    @required this.endChat,
    @required this.addChat,
    @required this.onReceiveMessage,
    @required Widget child,
  })  : assert(state != null),
        super(key: key, child: child);

  static AppStateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppStateContainer);
  }

  @override
  bool updateShouldNotify(AppStateContainer old) =>
      state != old.state || messages != old.messages || users != old.users;
}
