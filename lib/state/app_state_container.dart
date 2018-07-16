import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flores/flores.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/screens/chat_screen.dart';
import 'package:maui/repos/notif_repo.dart';
import 'package:maui/db/entity/notif.dart';

class AppStateContainerController extends StatefulWidget {
  final AppState state;
  final Widget child;

  AppStateContainerController({this.child, this.state});

  @override
  _AppStateContainerControllerState createState() =>
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
  List<Notif> notifs;
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool isShowingFlashCard = true;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
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

  Future _showNotification(
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
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    var split = payload.split(':');
    debugPrint('split $split');
    if (split[0] == 'chat') {
      User user = await UserRepo().getUser(split[1]);
      debugPrint('navigating to $user');
      await Navigator.push(
          context,
          MaterialPageRoute<Null>(
              builder: (BuildContext context) => new ChatScreen(
                  myId: state.loggedInUser.id,
                  friend: user,
                  friendImageUrl: user.image)));
    }
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
    await NotifRepo().delete(fId, 'chat');
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
    if (!(message['userId'] == friendId &&
        activity == 'chat' &&
        message['messageType'] == 'chat')) {
      await NotifRepo().increment(message['userId'], message['messageType'], 1);
    }
    if (message['messageType'] == 'Photo') {
      await UserRepo().insertOrUpdateRemoteUser(
          message['userId'], message['deviceId'], message['message']);
      if (activity == 'friends') {
        _getUsers();
      }
    } else if (message['recipientUserId'] == state.loggedInUser.id) {
      NotifRepo().increment(message['userId'], message['messageType'], 1);
      if (message['messageType'] == 'chat') {
        _showNotification(
            message['userId'],
            message['messageType'],
            message['message'],
            message['messageType'] + ':' + message['userId']);
        if (message['userId'] == friendId && activity == 'chat') {
          _beginChat(friendId);
        }
      } else {
        _showNotification(message['userId'], message['messageType'], '',
            message['messageType'] + ':' + message['userId']);
      }
    }
  }

  void _getUsers() async {
    activity = 'friends';
    final userList = await UserRepo().getRemoteUsers();
    final notifList = await NotifRepo().getNotifsByType('chat');
    setState(() {
      users = userList;
      notifs = notifList;
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
      notifs: notifs,
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
    prefs.setString('userId', user.id);
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
  List<Notif> notifs;
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
    @required this.notifs,
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
