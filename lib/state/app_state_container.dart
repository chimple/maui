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
      if(isShowingFlashCard) {
         showDialog(
          context: context,
          child:  new FractionallySizedBox(
              heightFactor: 0.5,
              widthFactor: 0.8,
              child: new FlashCard(text: fileName))).whenComplete((){isShowingFlashCard = true;});
      } else {
        null;
      }
      isShowingFlashCard = false;
  }

  @override
  Widget build(BuildContext context) {
    return new AppStateContainer(
      state: state,
      setLoggedInUser: _setLoggedInUser,
      play: _play,
      display: _display,
      child: widget.child,
    );
  }

  _setLoggedInUser(User user) {
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
  final Function(User user) setLoggedInUser;
  final Function(String string) play;
  final Function(BuildContext context,String string) display;

  const AppStateContainer({
    Key key,
    @required this.state,
    @required this.setLoggedInUser,
    @required this.play,
    @required this.display,
    @required Widget child,
  })  : assert(state != null),
        super(key: key, child: child);

  static AppStateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppStateContainer);
  }

  @override
  bool updateShouldNotify(AppStateContainer old) => state != old.state;
}
