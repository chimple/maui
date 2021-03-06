import 'dart:convert';

import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:maui/widgets/story/activity/start_game.dart';
import 'package:maui/widgets/story/audio_text_bold.dart';
import 'package:maui/util/text_to_speech.dart';
import 'package:maui/models/serializers.dart';
import 'package:maui/models/story_config.dart';
import 'package:flare_flutter/flare_actor.dart';

class StoryPage extends StatefulWidget {
  final String storyId;
  const StoryPage({Key key, this.storyId}) : super(key: key);
  @override
  StoryPageState createState() {
    return new StoryPageState();
  }
}

class StoryPageState extends State<StoryPage> {
  StoryConfig story;
  bool _isLoading = true;
  bool _isPlaying = false;
  int _currentPageIndex = 0;
  PageController pageController = PageController();
  List<FlutterTextToSpeech> _keys = List<FlutterTextToSpeech>();
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    print('story id ${widget.storyId}');
    final json =
        await rootBundle.loadString('assets/topic/${widget.storyId}.json');
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
    story = standardSerializers.deserialize(jsonDecode(json));
    for (int i = 0; i < story.pages.length; i++) {
      _keys.add(FlutterTextToSpeech());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    if (_isLoading) {
      return Center(
        child: new SizedBox(
          width: 20.0,
          height: 20.0,
          child: new CircularProgressIndicator(),
        ),
      );
    }
    final widgets = <Widget>[];
    story.pages.map((data) {
      widgets.add(AudioTextBold(
        playingStatus: (status) {
          if (status == TtsState.PLAYING) {
            setState(() {
              _isPlaying = true;
            });
          } else if (status == TtsState.PAUSE) {
            setState(() {
              _isPlaying = false;
            });
          }
        },
        onComplete: () {
          setState(() {
            _isPlaying = false;
          });
        },
        imagePath: data.imagePath,
        audioFile: data.audioPath,
        fullText: data.text,
        keys: _keys[index++],
        onLongPress: (s) {
          print(s);
        },
      ));
    }).toList();
    widgets.add(StartGame(
      gameData: story.gameDatas,
    ));
    return new Scaffold(
      //  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: _currentPageIndex != story.pages.length
      //     ? InkWell(
      //         onTap: () {
      //           if (!_isPlaying) {
      //             _keys[_currentPageIndex].speak();
      //           } else {
      //             _keys[_currentPageIndex].pause();
      //           }
      //         },
      //         child: Container(
      //           child: FlareActor('assets/chimp_ik.flr',animation: 'talking',)),
      //         // child: !_isPlaying ? Icon(Icons.play_arrow) : Icon(Icons.pause)
      //         )
      //     : Container(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset.zero, blurRadius: 4.0, color: Colors.grey)
                ],
                color: Colors.orange,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () => Navigator.of(context).pop()),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white, width: 2.0)),
                    child: Row(
                      children: <Widget>[
                        Text("15",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        Icon(Icons.star, color: Colors.yellow)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Scrollable(viewportBuilder: (c, k) {
                  return PageView(
                    controller: PageController(),
                    onPageChanged: (i) {
                      setState(() {
                        _isPlaying = false;
                        _currentPageIndex = i;
                      });
                    },
                    physics: !_isPlaying
                        ? ClampingScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: widgets,
                  );
                }),
                SizedBox(
                  height: 130,
                  width: 90,
                  child: _currentPageIndex != story.pages.length
                        ? GestureDetector(
                            onTap: () {
                              if (!_isPlaying) {
                                _keys[_currentPageIndex].speak();
                              } else {
                                _keys[_currentPageIndex].pause();
                              }
                            },
                            child: FlareActor(
                              'assets/character/chimp_iktest_loop.flr',
                              animation: 'talking',
                              fit: BoxFit.cover,
                              isPaused: !_isPlaying,
                            ),
                            // child: !_isPlaying ? Icon(Icons.play_arrow) : Icon(Icons.pause)
                          )
                        : Container(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
