import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/widgets.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/state/app_state.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

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
      await platform.invokeMethod('speak', <String, dynamic>{'text': fileName});
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

  @override
  Widget build(BuildContext context) {
    return new AppStateContainer(
      state: state,
      setLoggedInUser: _setLoggedInUser,
      play: _play,
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

  const AppStateContainer({
    Key key,
    @required this.state,
    @required this.setLoggedInUser,
    @required this.play,
    @required Widget child,
  })  : assert(state != null),
        super(key: key, child: child);

  static AppStateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppStateContainer);
  }

  @override
  bool updateShouldNotify(AppStateContainer old) => state != old.state;
}
