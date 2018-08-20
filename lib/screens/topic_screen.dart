import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/article_repo.dart';
import 'package:maui/repos/topic_repo.dart';
import 'package:maui/db/entity/article.dart';
import 'package:maui/db/entity/topic.dart';
import 'package:maui/screens/activity_list_view.dart';
import 'package:maui/screens/related_page.dart';
import 'package:maui/components/article_page.dart';
import 'package:maui/screens/select_opponent_screen.dart';

class TopicScreen extends StatefulWidget {
  final String topicId;
  TopicScreen({key, @required this.topicId}) : super(key: key);

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List<Article> _articles;
  Topic _topic;
  bool _isLoading = true;
  bool _isDataAvailable = false;
  bool _isForwardDisable = false;
  bool _isBackwardDisable = true;
  PageController pageController = new PageController(initialPage: 0);

  void _initTopic() async {
    await new TopicRepo().getTopic(widget.topicId).then((topic) {
      _topic = topic;
      new ArticleRepo()
          .getArticlesByTopicId(widget.topicId)
          .then((articles) async {
        setState(() {
          articles.sort((a, b) => a.serial.compareTo(b.serial));
          _articles = articles;
          _isLoading = false;
          _articles.length != 0
              ? _isDataAvailable = true
              : _isDataAvailable = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initTopic();
  }

  void _forwardButtonBehaviour() {
    pageController.nextPage(
        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    if (pageController.page == 0.0) {
      setState(() {
        _isBackwardDisable = false;
      });
    }
    if ((pageController.page + 1.0).toInt() == (_articles.length - 1)) {
      setState(() {
        _isForwardDisable = true;
      });
    }
  }

  void _backwardButtonBehaviour() {
    pageController.previousPage(
        duration: new Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    if ((pageController.page).toInt() == (_articles.length - 1)) {
      setState(() {
        _isForwardDisable = false;
      });
    }
    if (pageController.page - 1.0 == 0.0) {
      setState(() {
        _isBackwardDisable = true;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('loca topic_screen ${Loca.of(context)}');
    print(_articles);
    if (_isLoading == true) {
      return new CircularProgressIndicator();
    } else {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text(_topic.name),
            centerTitle: true,
            backgroundColor: Colors.teal[300],
            elevation: 5.0,
            actions: <Widget>[
              new IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return ActivityListView(
                      topicId: widget.topicId,
                    );
                  }));
                },
                icon: new Icon(Icons.local_activity),
              ),
              new IconButton(
                onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                      return SelectOpponentScreen(
                        gameName: 'quiz_pager',
                      );
                    })),
                icon: new Icon(Icons.games),
              ),
              new IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return RelatedPage(
                      topicId: widget.topicId,
                    );
                  }));
                },
                icon: new Icon(Icons.find_replace),
              )
            ],
          ),
          body: _isDataAvailable == false
              ? new Container(
                  child: new Center(
                    child: new Text(
                      Loca.of(context).no_data,
                      style: new TextStyle(
                          fontSize: 50.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : new Stack(
                  children: <Widget>[
                    new PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _articles.length,
                      controller: pageController,
                      itemBuilder: (context, index) {
                        return new ArticlePage(
                          topicId: _articles[index].topicId,
                          articleId: _articles[index].id,
                          name: _articles[index].name,
                          text: _articles[index].text,
                          audio: _articles[index].audio,
                          video: _articles[index].video,
                          image: _articles[index].image,
                          serial: _articles[index].serial,
                        );
                      },
                    ),
                    _articles.length > 1
                        ? new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Expanded(
                                flex: 2,
                                child: _isBackwardDisable
                                    ? new Container()
                                    : new IconButton(
                                        onPressed: () =>
                                            _backwardButtonBehaviour(),
                                        icon: new Icon(
                                          Icons.arrow_left,
                                          color: Colors.black,
                                        ),
                                        iconSize: 50.0,
                                      ),
                              ),
                              new Expanded(flex: 10, child: new Container()),
                              new Expanded(
                                flex: 2,
                                child: _isForwardDisable
                                    ? new Container()
                                    : new IconButton(
                                        onPressed: () =>
                                            _forwardButtonBehaviour(),
                                        icon: new Icon(
                                          Icons.arrow_right,
                                          color: Colors.black,
                                        ),
                                        iconSize: 50.0,
                                      ),
                              ),
                            ],
                          )
                        : new Container(),
                  ],
                ));
    }
  }
}
