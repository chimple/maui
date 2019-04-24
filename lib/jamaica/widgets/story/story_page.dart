import 'dart:convert';

import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/jamaica/widgets/story/activity/quiz_page.dart';
import 'package:maui/jamaica/widgets/story/audio_text_bold.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';
import 'package:maui/models/serializers.dart';
import 'package:maui/models/story_config.dart';

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
  PageController pageController = PageController();
  List<StoryMode> _storyMode = [];
  int incr = 0;

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
    for (int i = 0; i < story.pages.length; i++)
      _storyMode.add(StoryMode.textMode);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    int index = 0;
    final widgets = <Widget>[];
    story.pages.map((data) {
      widgets.add(AudioTextBold(
        imagePath: data.imagePath,
        audioFile: data.audioPath,
        fullText: data.text,
        onComplete: () => incr++,
        pageSliding: (index) => setState(() {
              _isPlaying = !_isPlaying;
            }),
        index: index++,
      ));
    }).toList();
    widgets.add(QuizPage(
      gameData: story.gameDatas,
    ));
    return new Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 90,
            child: Container(
              color: Colors.orange,
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
            child: Container(
                child: PageView(
              physics: !_isPlaying
                  ? ScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: widgets,
            )),
          )
        ],
      ),
    );
  }
}

// class ActivityButton extends StatelessWidget {
//   final IconData icon;
//   final String string;
//   final Function(int) onTap;
//   final int pageIndex;
//   final bool isEnable;
//   ActivityButton({
//     @required this.icon,
//     @required this.string,
//     @required this.onTap,
//     this.isEnable = false,
//     this.pageIndex,
//   });
//   @override
//   Widget build(BuildContext context) => Padding(
//       padding: const EdgeInsets.only(right: 0.0, bottom: 0.0),
//       child: Container(
//           width: 138,
//           height: 50,
//           child: RaisedButton(
//               color: Colors.white,
//               disabledColor: Colors.grey,
//               shape: RoundedRectangleBorder(
//                   side: BorderSide(width: 2.0, color: Colors.orange),
//                   borderRadius: BorderRadius.circular(25.0)),
//               onPressed: isEnable ? () => onTap(pageIndex) : null,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       string,
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Icon(icon, color: Colors.red, size: 30)
//                   ]))));
// }
