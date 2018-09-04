import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/article_repo.dart';
import 'package:maui/db/entity/article.dart';
import 'package:maui/components/article_page.dart';

class TopicPageView extends StatefulWidget {
  final String topicId;

  TopicPageView({key, @required this.topicId}) : super(key: key);
  @override
  _TopicPageViewState createState() => new _TopicPageViewState();
}

class _TopicPageViewState extends State<TopicPageView> {
  List<Article> _articles;
  bool _isDataAvailable = false;
  bool _isForwardDisable = false;
  bool _isBackwardDisable = true;
  PageController pageController = new PageController(initialPage: 0);

  void _initArticles() async {
    await new ArticleRepo()
        .getArticlesByTopicId(widget.topicId)
        .then((articles) async {
      setState(() {
        articles.sort((a, b) => a.serial.compareTo(b.serial));
        _articles = articles;
        _articles.length != 0
            ? _isDataAvailable = true
            : _isDataAvailable = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initArticles();
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
    return _isDataAvailable == false
        ? new Container(
            child: new Center(
              child: new Text(
                Loca.of(context).no_data,
                style:
                    new TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : new Stack(
            children: <Widget>[
              new PageView.builder(
                pageSnapping: false,
                physics: NeverScrollableScrollPhysics(),
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
                                  onPressed: () => _backwardButtonBehaviour(),
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
                                  onPressed: () => _forwardButtonBehaviour(),
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
          );
  }
}
