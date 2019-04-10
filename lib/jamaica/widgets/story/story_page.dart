import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/audio_text_bold.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';
import 'package:maui/models/story_config.dart';

class StoryPage extends StatefulWidget {
  final BuiltList<Page> pages;
  final String title;
  StoryPage({Key key, @required this.pages, this.title}) : super(key: key);

  @override
  StoryPageState createState() {
    return new StoryPageState();
  }
}

class StoryPageState extends State<StoryPage> {
  bool _isPlaying = false;
  PageController pageController = PageController();
  List<StoryMode> _storyMode = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pages.length; i++)
      _storyMode.add(StoryMode.textMode);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: PageView.builder(
        // pageSnapping: false,
        controller: pageController,
        onPageChanged: (int index) {
          print(index);
        },
        scrollDirection: Axis.vertical,
        physics: _isPlaying ? NeverScrollableScrollPhysics() : ScrollPhysics(),
        itemBuilder: (context, index) {
//          var d = widget.pages[index].imageItemsPosition;
//          print('drag data :: ${d}');
//          print('data:: ${widget.pages[index].highlightQuestion}');
          return AudioTextBold(
              imagePath: widget.pages[index].imagePath,
              audioFile: widget.pages[index].audioPath,
              fullText: widget.pages[index].text,
//              imageItemsAnswer: widget.pages[index].imageItemsAnswer,
              pageNumber: widget.pages[index].pageNumber,
              storyMode: _storyMode[index],
              index: index,
              storyModeCallback: (index, StoryMode sm) => setState(
                    () => _storyMode[index] = sm,
                  ),
              pageSliding: () => setState(() {
                    _isPlaying = !_isPlaying;
                    // pageController.jumpToPage(
                    //     int.parse(widget.pages[index].pageNumber) - 1);
                  }));
        },
        itemCount: widget.pages.length,
      ),
    );
  }
}
