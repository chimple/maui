import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/activity/activity_screen.dart';
import 'package:maui/jamaica/widgets/story/audio_text_bold.dart';
import 'package:maui/jamaica/widgets/story/cover_page.dart';
import 'package:maui/jamaica/widgets/story/show_dialog_mode.dart';
import 'package:maui/models/story_config.dart';

class StoryPage extends StatefulWidget {
  final BuiltList<Page> pages;
  final String title;
  final String coverImagePath;
  StoryPage({Key key, @required this.pages, this.title, this.coverImagePath})
      : super(key: key);

  @override
  StoryPageState createState() {
    return new StoryPageState();
  }
}

class StoryPageState extends State<StoryPage> {
  bool _isPlaying = false;
  PageController pageController = PageController();
  List<StoryMode> _storyMode = [];
  ScrollController _controller;
  int incr = 0;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pages.length; i++)
      _storyMode.add(StoryMode.textMode);
    _controller = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.pages.length);
    int index = 0;
    final widgets = <Widget>[];
    widgets.add(SizedBox(
      height: MediaQuery.of(context).size.height * 1.1,
      child: CoverPage(
        coverImagePath: widget.coverImagePath,
      ),
    ));
    widget.pages.map((data) {
      widgets.add(SizedBox(
        height: MediaQuery.of(context).size.height * 1.1,
        child: AudioTextBold(
            imagePath: data.imagePath,
            audioFile: data.audioPath,
            fullText: data.text,
            onComplete: () => incr++,
            pageSliding: (index) {
              setState(() {
                _isPlaying = !_isPlaying;
                _controller.animateTo(
                    (MediaQuery.of(context).size.height * 1.1 * (index + 1)),
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 500));
              });
            },
            index: index++,
//              imageItemsAnswer: widget.pages[index].imageItemsAnswer,
            pageNumber: data.pageNumber
            // storyMode: _storyMode[index],
            // index: index,
            ),
      ));
    }).toList();
    return new Scaffold(
      floatingActionButton: ActivityButton(
          isEnable: incr == widget.pages.length.toInt(),
          icon: Icons.pie_chart,
          string: "Activity",
          onTap: (i) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ActivityScreen()));
          }),
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
            flex: 1,
            child: Container(
                child: Scrollbar(
              child: SingleChildScrollView(
                  controller: _controller,
                  physics: _isPlaying
                      ? NeverScrollableScrollPhysics()
                      : ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: widgets,
                      ))),
            )),
          )
        ],
      ),
    );
  }
}

class ActivityButton extends StatelessWidget {
  final IconData icon;
  final String string;
  final Function(int) onTap;
  final int pageIndex;
  final bool isEnable;
  ActivityButton({
    @required this.icon,
    @required this.string,
    @required this.onTap,
    this.isEnable = false,
    this.pageIndex,
  });
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(right: 0.0, bottom: 0.0),
      child: Container(
          width: 138,
          height: 50,
          child: RaisedButton(
              color: Colors.white,
              disabledColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2.0, color: Colors.orange),
                  borderRadius: BorderRadius.circular(25.0)),
              onPressed: isEnable ? () => onTap(pageIndex) : null,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      string,
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(icon, color: Colors.red, size: 30)
                  ]))));
}
