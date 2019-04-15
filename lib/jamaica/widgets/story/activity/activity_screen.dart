import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/activity/drag_text.dart';
import 'package:maui/jamaica/widgets/story/activity/jumble_words.dart';
import 'package:maui/jamaica/widgets/story/activity/text_highlighter.dart';
import 'package:maui/jamaica/widgets/story/story_page.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => new _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  PageController _pageController;
  int pageIndex = 0;
  bool _isEnable = false;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: ActivityButton(
          icon: Icons.arrow_forward,
          isEnable: _isEnable,
          string: "Next",
          onTap: (index) {
            _pageController
                .nextPage(
                    curve: Curves.easeIn, duration: Duration(milliseconds: 500))
                .then((s) => setState(() => _isEnable = false));
          },
          pageIndex: pageIndex,
        ),
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
                          Icons.close,
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
              child: PageView(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  pageIndex = index;
                },
                children: <Widget>[
                  TextHighlighter(onComplete: (s) {
                    setState(() => _isEnable = true);
                  }),
                  DragText(
                    onComplete: (s) {
                      setState(() => _isEnable = true);
                    },
                  ),
                  JumbleWords(
                      answers: BuiltList<String>(
                          ["He", 'Like', 'to', 'tease', 'people']),
                      choices: BuiltList<String>(
                          ["He", 'Like', 'to', 'tease', 'people']),
                      onGameOver: (_) {},
                      onComplete: () {
                        setState(() => _isEnable = true);
                      })
                ],
              ),
            )
          ],
        ));
  }
}
