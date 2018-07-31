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
  bool _isDataAvailable = false;
  PageController pageController = new PageController(initialPage: 0);

  void _initTopic() async {
    new ArticleRepo()
        .getArticlesByTopicId(widget.topicId)
        .then((articles) async {
      setState(() {
        articles.sort((a, b) => a.order.compareTo(b.order));
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
    pageController.nextPage(
        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  _backwardButtonBehaviour() {
    pageController.previousPage(
        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
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
          body: _isDataAvailable == false
              ? new Container(
                  child: new Center(
                                      child: new Text(
                      "no data",
                      style: new TextStyle(
                          fontSize: 50.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : new Stack(
                  children: <Widget>[
                    new PageView(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      children: _createPageViewWidgets(context),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          flex: 2,
                          child: new IconButton(
                            onPressed: () => _backwardButtonBehaviour(),
                            icon: new Icon(Icons.arrow_left),
                            iconSize: 50.0,
                            disabledColor: Colors.grey,
                            splashColor: Colors.green,
                            highlightColor: Colors.white,
                          ),
                        ),
                        new Expanded(flex: 10, child: new Container()),
                        new Expanded(
                          flex: 2,
                          child: new IconButton(
                            onPressed: () => _forwardButtonBehaviour(),
                            icon: new Icon(Icons.arrow_right),
                            iconSize: 50.0,
                            disabledColor: Colors.grey,
                            splashColor: Colors.green,
                            highlightColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
    }
  }
}
