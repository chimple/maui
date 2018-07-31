import 'package:flutter/material.dart';
import 'package:maui/repos/article_repo.dart';
import 'package:maui/db/entity/article.dart';
import 'package:maui/components/article_page.dart';

class TopicScreen extends StatefulWidget {
  final String topicName;

  final String topicId;
  TopicScreen({key, @required this.topicName, @required this.topicId})
      : super(key: key);

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List<Article> _articles;
  List<Widget> _pageViewWidgets = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  bool _isDataAvailable = false;

  void _initTopic() async {
    new ArticleRepo()
        .getArticlesByTopicId(widget.topicId)
        .then((articles) async {
      setState(() {
        _articles = articles;
        _isLoading = false;
        _articles.length != 0
            ? _isDataAvailable = true
            : _isDataAvailable = false;
      });
    });
  }

  List<Widget> _createPageViewWidgets(BuildContext context) {
    for (var i = 0; i < _articles.length; i++) {
      _pageViewWidgets.add(new ArticlePage(
        topicId: _articles[i].topicId,
        articleId: _articles[i].id,
        name: _articles[i].name,
        text: _articles[i].text,
        audio: _articles[i].audio,
        video: _articles[i].video,
        image: _articles[i].image,
        order: _articles[i].order,
      ));
    }
    return _pageViewWidgets;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTopic();
  }

  _forwardButtonBehaviour() {
    if (_currentIndex < (_articles.length - 1)) {
      setState(() {
        _currentIndex += 1;
      });
    } else {
      print("curren index is at maximum");
    }
  }

  _backwardButtonBehaviour() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex -= 1;
      });
    } else {
      print("current index is at minimum");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("<<<<<<<<<<<<<<<$_articles>>>>>>>>>>>>>>>>>>>");
    if (_isLoading == true) {
      return new CircularProgressIndicator();
    } else {
      return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.topicName),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
        elevation: 5.0,
        actions: <Widget>[
          new IconButton(
            onPressed: () => print("object"),
            icon: new Icon(Icons.local_activity),
          ),
          new IconButton(
            onPressed: () => print("object"),
            icon: new Icon(Icons.games),
          ),
          new IconButton(
            onPressed: () => print("object"),
            icon: new Icon(Icons.find_replace),
          )
        ],
      ),
      body: new PageView(
            scrollDirection: Axis.horizontal,
            children: _createPageViewWidgets(context),
          ),
          // new Expanded(
          //   flex: 1,
          //   child: new IconButton(
          //     onPressed: () => _backwardButtonBehaviour(),
          //     icon: new Icon(Icons.arrow_left),
          //     iconSize: 50.0,
          //   ),
          // ),

          // (_isDataAvailable == false && _isLoading)
          //     ? new Expanded(
          //         flex: 16,
          //         child: new CircularProgressIndicator(),
          //       )
          //     : ((_isDataAvailable == false && _isLoading == false)
          //         ? new Expanded(
          //             flex: 16,
          //             child: new Center(
          //                 child: new Text(
          //               "no data",
          //               style:
          //                   new TextStyle(fontSize: 40.0, color: Colors.black),
          //             )),
          //           )
          //         : new Expanded(
          //             flex: 16,
          //             child: new ArticlePage(
          //               topicId: widget.topicId,
          //               articleId: _articles[_currentIndex].id,
          //               name: _articles[_currentIndex].name,
          //               audio: _articles[_currentIndex].audio,
          //               video: _articles[_currentIndex].video,
          //               text: _articles[_currentIndex].text,
          //               image: _articles[_currentIndex].image,
          //               order: _articles[_currentIndex].order,
          //             ),
          //           )),

          // // _isLoading == false
          // //     ? new Expanded(
          // //         flex: 16,
          // //         child: new ArticlePage(
          // //           topicId: widget.topicId,
          // //           articleId: _articles[_currentIndex].id,
          // //           name: _articles[_currentIndex].name,
          // //           audio: _articles[_currentIndex].audio,
          // //           video: _articles[_currentIndex].video,
          // //           text: _articles[_currentIndex].text,
          // //           image: _articles[_currentIndex].image,
          // //           order: _articles[_currentIndex].order,
          // //         ),
          // //       )
          // //     : new Expanded(
          // //         flex: 16,
          // //         child: new CircularProgressIndicator(),
          // //       ),
          // new Expanded(
          //   flex: 1,
          //   child: new IconButton(
          //     onPressed: () => _forwardButtonBehaviour(),
          //     icon: new Icon(Icons.arrow_right),
          //     iconSize: 50.0,
          //   ),
          // )
        );
    }
    
  }
}
